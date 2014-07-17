# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dock_test/version'

Gem::Specification.new do |spec|
  spec.name          = "dock_test"
  spec.version       = DockTest::VERSION
  spec.authors       = ["Jack Xu"]
  spec.email         = ["jackxxu@gmail.com"]
  spec.summary       = spec.description = %q{an outside-in service api test framework.}
  spec.homepage      = "https://github.com/jackxxu/dock_test"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'multi_json'
  spec.add_dependency 'rack'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
