module SpellBook
  VERSION = File.read(File.expand_path("../VERSION", File.dirname(__FILE__)))
end

require 'spellbook/app'
require 'spellbook/proxy'
require 'spellbook/server'
