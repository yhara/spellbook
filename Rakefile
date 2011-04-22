require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

desc "start server in port 3018"
task :server do
  sh "ruby bin/spellbook -p 3018 -e development"
end

#
# Rakefile to creating gems
#
# configurations:
PROJECT_NAME = File.basename(File.dirname(__FILE__))

require 'jeweler'

Jeweler::Tasks.new do |gemspec|
  gemspec.name = "#{PROJECT_NAME}"
  gemspec.summary = "Launcher for browser-based desktop applications "
  gemspec.email = "yutaka.hara/at/gmail.com"
  gemspec.homepage = "http://github.com/yhara/#{PROJECT_NAME}"
  gemspec.description = gemspec.summary
  gemspec.authors = ["Yutaka HARA"]
  gemspec.add_dependency('sinatra', '>= 1.2')
  gemspec.add_dependency('sinatra-activerecord', '= 0.1.3')
  gemspec.add_dependency('sqlite3')
  gemspec.add_dependency('slim')
  gemspec.add_dependency('sass')
  gemspec.add_dependency('childprocess')
  gemspec.add_development_dependency('rspec', '>= 2.0')
  gemspec.add_development_dependency('sinatra-reloader')
  gemspec.add_development_dependency('thin')
  gemspec.executables = ["spellbook"]
end

