require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

desc "start server in port 3018"
task :server do
  sh "ruby bin/spellbook -p 3018 -e development"
end

#
# Rakefile to creating gems
#
require 'bundler'
Bundler::GemHelper.install_tasks
