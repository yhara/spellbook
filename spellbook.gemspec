$:.push File.expand_path("../lib", __FILE__)
require "spellbook/version"

Gem::Specification.new do |s|
  s.name        = "spellbook"
  s.version     = SpellBook::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Yutaka HARA"]
  s.email       = ["yutaka.hara.gmail.com"]
  s.homepage    = "http://github.com/yhara/spellbook/"
  s.summary     = %q{Launcher for browser-based desktop applications}
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('activerecord', '>= 3.0')
  s.add_dependency('sinatra', '>= 1.2')
  s.add_dependency('sinatra-activerecord', '= 0.1.3')
  s.add_dependency('sqlite3')
  s.add_dependency('slim')
  s.add_dependency('slop')
  s.add_dependency('sass')
  s.add_dependency('rack-proxy')
  s.add_dependency('childprocess')

  s.add_development_dependency('capybara')
  s.add_development_dependency('thin')
  s.add_development_dependency('rack-test')
  s.add_development_dependency('rspec', '>= 2.0')
  s.add_development_dependency('sinatra-reloader')
end

