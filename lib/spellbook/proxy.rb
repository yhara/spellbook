require 'rack/proxy'

module SpellBook
  class Proxy < Rack::Proxy
    def initialize(port)
      @port = port
    end

    def rewrite_env(env)
      env["SERVER_PORT"] = @port.to_s
      env
    end
  end
end
