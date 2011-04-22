require 'slop'

opts = Slop.parse!(:help => true) do
  on 'p', 'port', true,        :default => 8080, :as => :integer
  on 'e', 'environment', true, :default => "production"
  on      'prefix', true,      :default => ""
end

require 'sinatra'

set :port, opts[:port]

get "#{opts[:prefix]}/" do
  "hi! this is a sample Spellbook application."
end
