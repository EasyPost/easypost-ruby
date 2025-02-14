# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easypost/version'
require 'bigdecimal'

Gem::Specification.new do |spec|
  spec.name = 'easypost'
  spec.version = EasyPost::VERSION
  spec.license = 'MIT'
  spec.summary = 'EasyPost Ruby Client Library'
  spec.description = 'Client library for accessing the EasyPost shipping API via Ruby.'
  spec.authors = 'EasyPost Developers'
  spec.email = 'oss@easypost.com'
  spec.homepage = 'https://www.easypost.com/docs'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(docs|examples|spec)/})
  end
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.6'

  spec.add_development_dependency 'brakeman', '~> 5.4'
  spec.add_development_dependency 'faraday', '~> 2.7.5' # used for integration tests
  spec.add_development_dependency 'pry', '~> 0.14'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rdoc', '~> 6.9'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.49'
  spec.add_development_dependency 'rubocop-rspec', '2.19' # pin to 2.19 because latest version doesn't support Ruby 2.6
  spec.add_development_dependency 'simplecov', '~> 0.22'
  spec.add_development_dependency 'simplecov-lcov', '~> 0.8'
  spec.add_development_dependency 'typhoeus', '~> 1.4.0' # used for integration tests
  spec.add_development_dependency 'vcr', '~> 6.1'
  spec.add_development_dependency 'webmock', '~> 3.18'
end
