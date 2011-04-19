require 'optparse'

port = prefix = nil
OptionParser.new{|o|
  o.on("--port PORT"){|n|
    port = n
  }
  o.on("--prefix PATH"){|s|
    prefix = s
  }
}.parse!(ARGV)

require 'sinatra'

set :port, (port || 12345)

get "#{prefix}/" do
  "hi"
end
