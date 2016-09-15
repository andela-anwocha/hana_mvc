# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hana/version'

Gem::Specification.new do |spec|
  spec.name          = 'hana'
  spec.version       = Hana::VERSION
  spec.authors       = ['adim']
  spec.email         = ['nwocha.adim@gmail.com']

  spec.summary       = 'A simple mvc framework'
  spec.description   = 'A simple mvc framework to understand the inner workings of rails'
  spec.homepage      = 'https://github.com/andela-anwocha'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   << 'hana'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'factory_girl'
  spec.add_development_dependency 'coveralls'

  spec.add_runtime_dependency 'pry'
  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'tilt'
  spec.add_runtime_dependency 'sqlite3'
  spec.add_runtime_dependency 'json'
  spec.add_runtime_dependency 'thor'
end
