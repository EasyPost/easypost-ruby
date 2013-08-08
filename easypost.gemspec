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
  spec.authors     = ['Jon Calhoun', 'Sawyer Bateman']
  spec.email       = 'contact@easypost.com'
  spec.homepage    = 'https://www.easypost.com/docs'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- test/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_path  = 'lib'

  spec.add_dependency('rest-client', '~> 1.4')
  spec.add_dependency('multi_json', '>= 1.0.4', '< 2')
  spec.add_development_dependency('rspec', "~> 2.13.0")
end
