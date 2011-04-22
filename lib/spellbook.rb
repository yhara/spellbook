module SpellBook
  VERSION = File.read(File.expand_path("../VERSION", File.dirname(__FILE__)))
end

require 'sinatra/activerecord'

require 'spellbook/proxy'
require 'spellbook/app'
require 'spellbook/server'
