# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easypost/version'

Gem::Specification.new do |spec|
  spec.name        = 'easypost'
  spec.version     = EasyPost::VERSION
  spec.date        = Time.now.strftime("%Y-%m-%d")
  spec.summary     = 'EasyPost Ruby Client Library'
  spec.description = 'Client library for accessing the EasyPost shipping API via Ruby.'
  spec.authors     = ['Sawyer Bateman']
  spec.email       = 'contact@easypost.com'
  spec.homepage    = 'https://www.easypost.com/docs'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rest-client', '~> 1.4'
  spec.add_dependency 'multi_json', '>= 1.0.4', '< 2'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 2.13.0'
end
