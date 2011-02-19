require 'pathname'
require 'spellbook'
require 'sinatra/base'
require 'slim'

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

    get '/' do
      slim :index
    end
  end
end
