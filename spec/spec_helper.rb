$LOAD_PATH << "#{File.dirname __FILE__}/../lib"
require 'spellbook'
require 'rspec'
require 'rack/test'
require 'capybara/rspec'
require 'capybara/dsl' 

RSpec.configure do |config| 
  config.include(Capybara)
end
