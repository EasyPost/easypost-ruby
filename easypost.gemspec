# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "easypost/version"

Gem::Specification.new do |spec|
  spec.name = "easypost"
  spec.version = EasyPost::VERSION
  spec.date = Time.now.strftime("%Y-%m-%d")
  spec.summary = "EasyPost Ruby Client Library"
  spec.description = "Client library for accessing the EasyPost shipping API via Ruby."
  spec.authors = ["Jake Epstein", "Andrew Tribone", "James Brown"]
  spec.email = "support@easypost.com"
  spec.homepage = "https://www.easypost.com/docs"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = "~> 2.5"

  spec.add_dependency "rest-client", "~> 2.1"
  spec.add_dependency 'multi_json', '~> 1.14'
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "pry", "~> 0.13"
end
