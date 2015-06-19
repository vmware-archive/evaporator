# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'evaporator/version'

Gem::Specification.new do |spec|
  spec.name          = 'evaporator'
  spec.version       = Evaporator::VERSION
  spec.authors       = ['IAD Developers']
  spec.email         = ['iad-dev@pivotal.io']

  spec.summary       = %q{A collection of rake tasks that make it easy to deploy to Cloud Foundry.}
  spec.description   = %q{A collection of rake tasks that make it easy to deploy to Cloud Foundry.}
  spec.homepage      = 'http://pivotal.io'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('rails', '~> 4.0')

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
