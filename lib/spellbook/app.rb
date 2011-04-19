require 'sinatra/activerecord'

module SpellBook
  class App < ActiveRecord::Base
    validates_presence_of :name, :port, :command
    validates_uniqueness_of :name, :port
    validates_numericality_of :port
  end
end
