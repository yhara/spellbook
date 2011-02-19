require 'spellbook'
require 'sinatra/base'

module SpellBook
  class Server < Sinatra::Base
    get '/' do
      "hi"
    end
  end
end
