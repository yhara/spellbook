$LOAD_PATH << "#{File.dirname __FILE__}/../lib"
require 'spellbook'
require 'rspec'
require 'rack/test'
require 'capybara/rspec'
require 'capybara/dsl' 

module SpellBook
  def self.opts
    {:environment => "test"}
  end
end

RSpec.configure do |config| 
  config.include(Capybara)
end
