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
    get '/' do
      slim <<-EOD
h1 SpellBook

p
  | hi
      EOD
    end
  end
end
