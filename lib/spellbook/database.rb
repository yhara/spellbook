require 'forwardable'

module SpellBook
  class Database
    extend Forwardable

    def initialize(path)
      @path = path
      @data = load_data
      super(@data)
    end

    def_delegators :@data, :[], :each

    def save_data
      File.open(@path, "wb"){|f|
        Marshal.dump(@data, f)
      }
    end

    def []=(k, v)
      @data[k] = v
      save_data
    end

    private

    def default_data
      {}
    end

    def load_data
      if File.exist?(@path)
        File.open(@path){|f|
          Marshal.load(f)
        }
      else
        default_data
      end
    end

  end
end
