# Load RubyGems; You need these gems installed:
#   $ sudo gem install sinatra slop
require 'rubygems'

#
# Parse command-line options
#

# Slop is a handy library to parse command-line options.
require 'slop'
$opts = Slop.parse!(:help => true) do
  on 'p', 'port', true,        :default => 8080, :as => :integer
  on      'prefix', true,      :default => ""
end

#
# Sample Sinatra app
#

require 'sinatra'

# Use the HTTP port specified with --port
set :port, $opts[:port]

# Top page
get "#{$opts[:prefix]}/" do
  @dice = rand(6) + 1
  erb :index
end

# Help page
get "#{$opts[:prefix]}/whatsthis" do
  @proxy_url = "http://localhost:3017#{$opts[:prefix]}/whatsthis"
  @real_url = "http://localhost:#{$opts[:port]}#{$opts[:prefix]}/whatsthis"
  erb :help
end

# Views (embedded)

__END__

@@layout
  <!DOCTYPE html>
  <html>
    <head>
    <style>
      body { margin-left: 20%; margin-right: 20%; }
      .box { border: 1px solid gray; padding: 1em; }
      .dice { font-size: x-large; }
      dt { font-weight: bold; }
    </style>
    </head>
    <body>
      <h1>
        <a href="<%= $opts[:prefix] %>/">
          <font color="red">D</font><font color="blue">i</font><font color="orange">c</font><font color="green">e</font>
        </a>
      </h1>

      <%= yield %>
    </body>
  </html>

@@index
  <p class="dice">
  [
    <% if @dice == 1 %>
      <font color="red">1</font>
    <% else %>
      <%= @dice %>
    <% end %>
  ]
  </p>
  <a href="<%= $opts[:prefix] %>/">
    Roll again!
  </a>
  <br><br><br>
  <a href="<%= $opts[:prefix] %>/whatsthis">
    What's this?
  </a>

@@help
  <h2>What's this?</h2>
  <div class="box">
    <p>This is a sample application for Spellbook.</p>
  </div>

  <h2>How to make Spellbook apps</h2>
  <div class="box">
    <p>
      A Spellbook app is just a web application runs on localhost.
      You can make Spellbook apps with your favorite programming language!
    </p>
    <p>
      The only rule is that your app must take these options:
      --port and --prefix.
    </p>
    <dl>
      <dt>--port=XXX</dt><dd>HTTP port number.</dd>
      <dt>--prefix=YYY</dt><dd>Prefix included in url.</dd>
    </dl>
    <p>
      When Spellbook invokes an app, it passes these options like this:
    </p>

    <pre>$ /some/where/yourapp --port=<%= $opts[:port] %> --prefix="<%= $opts[:prefix] %>"</pre>

    <p>
      Then, Spellbook acts like a proxy server.<br>
      This url (
        <a href="<%= @proxy_url %>">
          <%= @proxy_url %>
        </a>
      ) <br>
      shows the content of
        <a href="<%= @real_url %>">
          <%= @real_url %>
        </a>.
    </p>
    <p>
      This sample app is written in Ruby and Sinatra.
      See <%= File.expand_path __FILE__ %> for details.
    </p>
  </div>
