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
  spec.description   = %q{Slices a Cucumber test suite into the smallest possible executable pieces (i.e. scenarios and individual outline example rows. These pieces can then be more easily used for running tests in parallel.}
  spec.homepage      = "https://github.com/enkessler/cuke_slicer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3', '< 4.0'

  spec.add_runtime_dependency "cuke_modeler", "< 4.0"

  spec.add_development_dependency 'bundler', '< 3.0'
  spec.add_development_dependency 'rake', '< 13.0.0'
  spec.add_development_dependency "rspec", '~> 3.0'
  spec.add_development_dependency 'cucumber', '< 5.0.0'
  spec.add_development_dependency 'simplecov', '<= 0.16.1' # Coveralls gem does not support any newer version than this
  spec.add_development_dependency "racatt", '~> 1.0'
  spec.add_development_dependency 'coveralls', '< 1.0.0'
  spec.add_development_dependency 'rainbow', '< 4.0.0'

end
