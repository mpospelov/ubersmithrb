# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ubersmithrb/version'

Gem::Specification.new do |gem|
  gem.name          = "ubersmithrb"
  gem.version       = Ubersmith::VERSION
  gem.authors       = ["Matt Kennedy"]
  gem.email         = ["mkennedy@object-brewery.com"]
  gem.description   = %q{A ruby gem for communicating with the Ubersmith API}
  gem.summary       = %q{This gem allows a programmer to connect and send commands to an Ubersmith server from their own application.}
  gem.homepage      = "https://github.com/mchkennedy/ubersmithrb"
  gem.has_rdoc      = true
  gem.add_development_dependency  'rspec', '~> 3.8.0'
  gem.add_development_dependency  'byebug', '~> 11.0.1'
  gem.add_development_dependency  'simplecov', '~> 0.17.0'
  gem.add_runtime_dependency 'oj', '>= 3.9.0'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
