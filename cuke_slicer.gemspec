# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cuke_slicer/version'

Gem::Specification.new do |spec|
  spec.name          = "cuke_slicer"
  spec.version       = CukeSlicer::VERSION
  spec.authors       = ["Eric Kessler"]
  spec.email         = ["morrow748@gmail.com"]
  spec.summary       = %q{A gem for extracting test cases from a Cucumber test suite.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/grange-insurance/cuke_slicer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "cuke_modeler", "~> 1.0.3"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", '~> 3.0'
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "racatt"
end
