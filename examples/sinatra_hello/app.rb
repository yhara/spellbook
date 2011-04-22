# Load RubyGems; You need these gems installed:
#   $ sudo gem install sinatra slim slop
require 'rubygems'

#
# Parse command-line options
#

# Slop is a handy library to parse command-line options.
require 'slop'
opts = Slop.parse!(:help => true) do
  on 'p', 'port', true,        :default => 8080, :as => :integer
  on      'prefix', true,      :default => ""
end

#
# Sample Sinatra app
#

require 'sinatra'
# Slim is a indent-based template engine.
# You can also use Haml, ERB, etc. instead.
require 'slim'

# Use the HTTP port specified with --port
set :port, opts[:port]

# Top page

get "#{opts[:prefix]}/" do
  slim <<-EOD
head
  style
    | body { margin-left: 20%; margin-right: 20%; }

body
  h1 Dice
  div
    = "[#{rand(6)+1}]"

  div
    a href="#{opts[:prefix]}/"
      | roll again!

  br
  br
  br

  a href="#{opts[:prefix]}/whatsthis"
    | What's this?

  EOD
end

# Help page

get "#{opts[:prefix]}/whatsthis" do
  slim <<-EOD
head
  style
    | body { margin-left: 20%; margin-right: 20%; }
      .box { border: 1px solid gray; padding: 1em; }
      dt { font-weight: bold; }
body
  h1
    a href="#{opts[:prefix]}/"
      | Dice

  h2 What's this?
  div.box
    p
      | This is a sample application for Spellbook.

  h2 How to make Spellbook apps
  div.box
    p   
      | A Spellbook app is just a web application runs on localhost. You can make Spellbook apps with your favorite programming language!

    p 
      | The only rule is that your app must take these options: --port and --prefix.

    dl
      dt --port=XXX
      dd
        | HTTP port number.

      dt --prefix=YYY
      dd
        | Prefix included in url.

    p 
      | When Spellbook invokes an app, it passes these options like this:

    pre $ /some/where/yourapp --port=#{opts[:port]} --prefix="#{opts[:prefix]}"

    p 
      | Then, Spellbook acts like a proxy server.
      br
      ' The URL (
      a href="http://localhost:3017#{opts[:prefix]}/whatsthis"
        = "http://localhost:3017#{opts[:prefix]}/whatsthis"
      '  )
      br
      ' is a proxy to
      a href="http://localhost:#{opts[:port]}#{opts[:prefix]}/whatsthis"
        = "http://localhost:#{opts[:port]}#{opts[:prefix]}/whatsthis"
      | .

    p
      | This sample app is written in Ruby and Sinatra. See #{File.expand_path __FILE__} for details.
  
  EOD
end
