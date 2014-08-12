# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elastic/dsl/version'

Gem::Specification.new do |spec|
  spec.name          = 'elastic-dsl'
  spec.version       = Elastic::DSL::VERSION
  spec.authors       = ['Zachary Moshansky']
  spec.email         = ['zmoshansky@gmail.com']
  spec.description   = 'DSL Builder for Elasticsearch. (Not Affiliated)'
  spec.summary       = 'DSL Builder for Elasticsearch.'
  spec.homepage      = 'https://github.com/zmoshansky/elastic-dsl'
  spec.license       = 'Apache 2'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-core'
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'rspec-expectations'

  spec.add_development_dependency 'guard', '~> 2.0'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'terminal-notifier-guard'

  spec.add_development_dependency 'simplecov', '~> 0.9'

  # spec.add_development_dependency 'activesupport'
  # Hash with Indifferent Access

end
