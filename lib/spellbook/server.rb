require 'pathname'
require 'sinatra/base'
require 'slim'
require 'childprocess'

module SpellBook

  class Server < Sinatra::Base
    use Rack::MethodOverride

    cattr_accessor :processes

    DATA_PATH = File.expand_path("~/.spellbook.db")
    configure do
      here = Pathname(__FILE__).dirname
      set :views, (here + "views").to_s

      set :database, "sqlite://#{DATA_PATH}"

      Server.processes = {}
    end

    helpers do
      def running?(app)
        process = Server.processes[app.id] 
        process and process.alive?
      end

      def app_params(params)
        {
          :name => params[:name],
          :port => params[:port].to_i,
          :command => params[:command],
          :proxy => (params[:proxy] == "on")
        }
      end
    end

    # top
    get '/' do
      slim :top
    end

    # apps#index
    get '/spellbook/apps/?' do
      @apps = App.all
      slim :apps_index
    end

    # apps#new
    get '/spellbook/apps/new' do
      slim :apps_new
    end

    # apps#create
    post '/spellbook/apps/?' do
      App.new(app_params(params)).save!

      redirect "/spellbook/apps/"
    end
    
    # apps#edit
    get '/spellbook/apps/:name/edit' do
      @app = App.find_by_name(params[:name])
      slim :apps_edit
    end
    
    # apps#update
    put '/spellbook/apps/:name' do
      app = App.find_by_name(params[:name])
      app.name = params[:name]
      app.port = params[:port]
      app.command = params[:command]
      app.save!

      redirect "/spellbook/apps/"
    end
    
    # apps#start
    get '/spellbook/apps/:name/start' do
      app = App.find_by_name(params[:name])

      process = ChildProcess.build(*app.command.split, 
                                   "--port", app.port.to_s,
                                   "--prefix", "/#{app.name}")
      Server.processes[app.id] = process

      process.io.inherit!
      process.start

      redirect "/spellbook/apps/"
    end
    
    # apps#stop
    get '/spellbook/apps/:name/stop' do
      app = App.find_by_name(params[:name])

      process = Server.processes[app.id]
      process.stop if process

      redirect "/spellbook/apps/"
    end

    # proxy
    get '/:name/*' do
      app = App.find_by_name(params[:name])

      if app
        SpellBook::Proxy.new(app.port).call(request.env)
      else
        pass  # shows sinatra's default error page
      end
    end
    
  end
end
