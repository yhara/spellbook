$LOAD_PATH << "#{File.dirname __FILE__}/../lib"
require 'spellbook'
require 'rspec'
require 'rack/test'

SpellBook::Server.set :environment, :test

describe "Spellbook::Server" do
  include Rack::Test::Methods

  def app
    SpellBook::Server
  end

  context "GET /" do
    it "should redirect to /spellbook/apps" do
      get '/'
      last_response.status.should == 302
      last_response.headers["Location"].should =~ %r{/spellbook/apps$}
    end
  end

  context "GET apps#index" do
    it "should show list of apps" do
      get '/spellbook/apps'
      last_response.should be_ok
    end
  end

  context "GET apps#new" do
    it "should show the form" do
      get '/spellbook/apps/new'
      last_response.should be_ok
    end
  end

  context "POST apps#create" do
    it "should create an app" do
      app_data = {
        :name => "Sample app",
        :port => 12345,
        :proxy => "1",
      }
      post '/spellbook/apps/', app_data
      last_response.should be_ok
    end
  end
end
