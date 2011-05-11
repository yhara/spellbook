require 'rack/proxy'

module SpellBook
  class Proxy < Rack::Proxy
    def initialize(port)
      @port = port
    end

    def rewrite_env(env)
      env["SERVER_NAME"] = "localhost"
      env["SERVER_PORT"] = @port.to_s
      env["HTTP_HOST"] = "localhost:#{@port}"
      env
    end
  end
end
