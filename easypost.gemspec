# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easypost/version'

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
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.7'

  spec.add_development_dependency 'abbrev', '~> 0.1'
  spec.add_development_dependency 'benchmark', '~> 0.4'
  spec.add_development_dependency 'bigdecimal', '~> 3'
  spec.add_development_dependency 'brakeman', '~> 5.4' # can't upgrade to 6.x, requires Ruby 3.0
  spec.add_development_dependency 'faraday', '~> 2.8' # can't upgrade to 2.9, requires Ruby 3.0
  spec.add_development_dependency 'logger', '~> 1'
  spec.add_development_dependency 'ostruct', '~> 0.6'
  spec.add_development_dependency 'rdoc', '~> 6.12'
  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'rubocop', '= 1.73'
  spec.add_development_dependency 'rubocop-rspec', '2.31' # can't upgrade to 3.0, requires easycop config changes
  spec.add_development_dependency 'simplecov', '~> 0.22'
  spec.add_development_dependency 'simplecov-lcov', '~> 0.8'
  spec.add_development_dependency 'typhoeus', '~> 1.4'
  spec.add_development_dependency 'vcr', '~> 6.3'
  spec.add_development_dependency 'webmock', '~> 3.25'
end
