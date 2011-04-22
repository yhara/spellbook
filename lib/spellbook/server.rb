require 'tempfile'
require 'sinatra/base'
require 'slim'
require 'childprocess'

module SpellBook

  def self.path_to(path)
    top = File.expand_path("../../", File.dirname(__FILE__))
    File.expand_path(path, top)
  end

  class Server < Sinatra::Base
    use Rack::MethodOverride

    cattr_accessor :processes

    configure do
      set :port, SpellBook.opts[:port] || 3017
      set :environment, SpellBook.opts[:environment] || "production"

      set :views, SpellBook.path_to("lib/spellbook/views/")
      Server.processes = {}
    end

    configure :test do
      set :database_path, SpellBook.path_to("db/test.db")
      ActiveRecord::Base.logger.level = 4
    end

    configure :development do
      set :database_path, SpellBook.path_to("db/development.db")

      require 'sinatra/reloader'
      register Sinatra::Reloader
      #also_reload "lib/**/*.rb"
    end

    configure :production do
      set :database_path, File.expand_path("~/.spellbook.db")
      ActiveRecord::Base.logger.level = 4
    end

    configure do
      path = File.expand_path(SpellBook.opts[:data] ||
                              settings.database_path)

      ActiveRecord::Base.establish_connection(
        :adapter => "sqlite3",
        :database => path,
      )
      ActiveRecord::Migrator.migrate(SpellBook.path_to('db/migrate'))

      if settings.environment != "test"
        puts "Spellbook version #{SpellBook::VERSION}"
        puts "database: #{path}"
        puts

        if App.count == 0
          puts "Registering sample app.."
          app_path = SpellBook.path_to("examples/sinatra_hello/app.rb")
          App.create!(
            :name => "Sample app",
            :port => 40000,
            :command => "ruby #{app_path}",
            :proxy => true
          )
        end
      end
    end

    helpers do
      def running?(app)
        process = Server.processes[app.id] 
        process and process.alive?
      end

      def find_app(name)
        App.find_by_name(name) or
          raise "Application named `#{name}' was not found."
      end
    end

    before do
      # Remove the _method param used for PUT and DELETE
      # for ActiveRecord mass-assignment
      params.delete("_method")
    end

    # css
    get '/screen.css' do
      sass :screen
    end

    # top
    get '/' do
      #slim :top
      redirect '/spellbook/apps'
    end

    # apps#index
    get '/spellbook/apps/?' do
      @apps = App.all
      slim :apps_index
    end

    # apps#new
    get '/spellbook/apps/new' do
      begin
        @port = rand(10000) + 40000
      end while App.find_by_port(@port)

      slim :apps_new
    end

    # apps#create
    post '/spellbook/apps/?' do
      App.new(params).save!

      redirect "/spellbook/apps/"
    end
    
    # apps#edit
    get '/spellbook/apps/:name/edit' do
      @app = find_app(params[:name])
      slim :apps_edit
    end
    
    # apps#update
    put '/spellbook/apps/:name' do
      app = find_app(params[:name])
      app.update_attributes(params)
      app.save!

      redirect "/spellbook/apps/"
    end
    
    # apps#start
    get '/spellbook/apps/:name/start' do
      app = find_app(params[:name])

      process = ChildProcess.build(*app.command.split, 
                                   "--port", app.port.to_s,
                                   "--prefix", "/#{app.name}")
      Server.processes[app.id] = process

      tempfile = Tempfile.new("spellbook")
      process.io.stdout = tempfile
      process.io.stderr = tempfile

      process.start

      sleep 1

      if process.exited?
        tempfile.close
        raise "failed to start `#{app.name}':\n\n#{File.read tempfile.path}"
      end

      redirect "/spellbook/apps/"
    end
    
    # apps#stop
    get '/spellbook/apps/:name/stop' do
      app = find_app(params[:name])

      process = Server.processes[app.id]
      process.stop if process

      redirect "/spellbook/apps/"
    end

    # proxy
    get '/:name/*' do
      app = find_app(params[:name])

      if app
        n = 0
        begin
          SpellBook::Proxy.new(app.port).call(request.env)
        rescue Errno::ECONNREFUSED => e
          if n < 10
            n += 1
            sleep 1
            retry
          else
            raise e
          end
        end
      else
        pass  # shows sinatra's default error page
      end
    end

    # exceptions
    error do
      @err = env["sinatra.error"]
      slim :error
    end
    
  end
end
