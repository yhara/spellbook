module SpellBook
  class App < ActiveRecord::Base
    validates_presence_of :name, :port, :command
    validates_uniqueness_of :name, :port
    validates_numericality_of :port

    def url
      if self.proxy
        "/#{self.name}/"
      else
        "http://localhost:#{self.port}/#{self.name}/"
      end
    end
  end
  #require 'irb'; IRB.start
end
