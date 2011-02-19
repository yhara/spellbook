require 'fileutils'
require 'spellbook/database'

describe SpellBook::Database do

  DATA_PATH = File.expand_path("tmp.db", File.dirname(__FILE__))

  it "should create file" do
    File.exist?(DATA_PATH).should be_false

    db = SpellBook::Database.new(DATA_PATH)
    db.save_data

    File.exist?(DATA_PATH).should be_true
  end

  it "should save and restore data" do
    db = SpellBook::Database.new(DATA_PATH)
    db[:foo] = :bar
    db.save_data
    
    db2 = SpellBook::Database.new(DATA_PATH)
    db2[:foo].should == :bar
  end

  after :all do
    FileUtils.rm(DATA_PATH)
  end
end
