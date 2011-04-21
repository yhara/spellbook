require "#{File.dirname __FILE__}/spec_helper.rb"

SpellBook::Server.set :environment, :test

Capybara.app = SpellBook::Server

App = SpellBook::App

describe "Spellbook::Server" do
  include Rack::Test::Methods

  def app
    SpellBook::Server
  end

  before :each do
    App.destroy_all
  end

  describe "GET /" do
    it "should redirect to /spellbook/apps" do
      get '/'
      last_response.status.should == 302
      last_response.headers["Location"].should =~ %r{/spellbook/apps$}
    end
  end

  describe "GET apps#index" do
    it "should show list of apps" do
      get '/spellbook/apps'
      last_response.should be_ok
    end
  end

  describe "GET apps#new - POST apps#create" do
    it "should create an app with proxy ON" do
      lambda {
        visit '/spellbook/apps/new'

        fill_in 'name', :with => "Sample app"
        fill_in 'port', :with => 12345
        fill_in 'command', :with => "ruby someapp.rb"
        check 'proxy'

        click_button "save"
      }.should change(App, :count).by 1

      App.first.proxy.should be_true
    end

    it "should create an app with proxy OFF" do
      lambda {
        visit '/spellbook/apps/new'

        fill_in 'name', :with => "Sample app"
        fill_in 'port', :with => 12345
        fill_in 'command', :with => "ruby someapp.rb"
        uncheck 'proxy'

        click_button "save"
      }.should change(App, :count).by 1

      App.first.proxy.should be_false
    end
  end
end
