require 'forwardable'

module SpellBook
  class Database
    extend Forwardable

    def initialize(path, default)
      @path = path
      @data = load_data(default)
      super(@data)
    end

    def_delegators :@data, :[], :[]=, :each

    def save_data
      File.open(@path, "wb"){|f|
        Marshal.dump(@data, f)
      }
    end
    alias save save_data

    private

    def load_data(default={})
      if File.exist?(@path)
        File.open(@path){|f|
          Marshal.load(f)
        }
      else
        default
      end
    end

  end
end
