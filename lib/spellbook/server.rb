require 'pathname'
require 'sinatra/base'
require 'slim'
require 'hashie/mash'
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
  class Server < Sinatra::Base
    here = Pathname(__FILE__).dirname
    set :views, (here + "views").to_s

    DATA_PATH = File.expand_path("~/.spellbook.marshal")
    configure do
      set :db, Database.new(DATA_PATH, {
        :apps => {}
      })
    end

    helpers do
      def db
        settings.db
      end
    end

    # top
    get '/' do
      slim :top
    end

    # apps#index
    get '/spellbook/apps/?' do
      p db.instance_variable_get :@data
      slim :apps_index
    end

    # apps#new
    get '/spellbook/apps/new' do
      slim :apps_new
    end

    # apps#create
    post '/spellbook/apps/?' do
      app = {
        :name => params[:name],
        :port => params[:port],
        :command => params[:command],
      }
      db[:apps][app[:name]] = app
      db.save

      redirect "/spellbook/apps/"
    end
    
    # apps#edit
    get '/spellbook/apps/:name/edit' do
      @app = Hashie::Mash.new(db[:apps][params[:name]])
      slim :apps_edit
    end
    
    # apps#update
    put '/spellbook/apps/:name' do
      app = {
        :name => params[:name],
        :port => params[:port],
        :command => params[:command],
      }
      db[:apps][params[:name]] = app
      db.save

      redirect "/spellbook/apps/"
    end
    
    # apps#start
    get '/spellbook/apps/:name/start' do
      params[:name]
    end

    
  end
end
