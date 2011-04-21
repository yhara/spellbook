$LOAD_PATH.unshift "#{File.dirname __FILE__}/lib"

require 'spellbook'
run SpellBook::Server
