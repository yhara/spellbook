require 'pathname'
require 'sinatra/base'
require 'slim'
require 'childprocess'

require 'spellbook/database'

module Sinatra
  module Templates
    unless defined? slim
      def slim(template, options={}, locals={})
        render :slim, template, options, locals
      end
    end
  end
end

module SpellBook
  class App
    def initialize(params)
      @name, @port, @command = params[:name], params[:port], params[:command]
      @process = nil
    end
    attr_accessor :name, :port, :command
    attr_accessor :process

    def running?
      @process and @process.alive?
    end
  end

  class Server < Sinatra::Base
    use Rack::MethodOverride

    here = Pathname(__FILE__).dirname
    set :views, (here + "views").to_s

    DATA_PATH = File.expand_path("~/.spellbook.marshal")
    configure do
      set :db, Database.new(DATA_PATH, {
        :apps => []
      })

      set :processes, {}
    end

    helpers do
      def db
        settings.db
      end

      def find_app(name)
        db[:apps].find{|app| app.name == name}
      end
    end

    # top
    get '/' do
      slim :top
    end

    # apps#index
    get '/spellbook/apps/?' do
      slim :apps_index
    end

    # apps#new
    get '/spellbook/apps/new' do
      slim :apps_new
    end

    # apps#create
    post '/spellbook/apps/?' do
      db[:apps] << App.new(params)
      db.save

      redirect "/spellbook/apps/"
    end
    
    # apps#edit
    get '/spellbook/apps/:id/edit' do
      @app = find_app(params[:id])
      slim :apps_edit
    end
    
    # apps#update
    put '/spellbook/apps/:id' do
      @app = find_app(params[:id])
      app.name = params[:name]
      app.port = params[:port]
      app.command = params[:command]
      db.save

      redirect "/spellbook/apps/"
    end
    
    # apps#start
    get '/spellbook/apps/:id/start' do
      @app = find_app(params[:id])
      @app.process = ChildProcess.build(@app.command, 
                                        "--port", @app.port,
                                        "--prefix", @app.name)

      p @app.process
      #@app.process.io.inherit!
      @app.process.start
      p @app.process
      3.times do |i|
        p 1
        sleep 1
      end
      #redirect "/spellbook/apps/"
      render :apps_index
    end
    
  end
end
