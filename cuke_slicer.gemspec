lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cuke_slicer/version'

Gem::Specification.new do |spec|
  spec.name          = 'cuke_slicer'
  spec.version       = CukeSlicer::VERSION
  spec.authors       = ['Eric Kessler']
  spec.email         = ['morrow748@gmail.com']
  spec.summary       = 'A gem for extracting test cases from a Cucumber test suite.'
  spec.description   = ['Slices a Cucumber test suite into the smallest possible executable pieces (i.e. scenarios ',
                        'and individual outline example rows. These pieces can then be more easily used for running ',
                        'tests in parallel.'].join
  spec.homepage      = 'https://github.com/enkessler/cuke_slicer'
  spec.license       = 'MIT'

  spec.metadata = {
    'bug_tracker_uri'   => 'https://github.com/enkessler/cuke_slicer/issues',
    'changelog_uri'     => 'https://github.com/enkessler/cuke_slicer/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/cuke_slicer',
    'homepage_uri'      => 'https://github.com/enkessler/cuke_slicer',
    'source_code_uri'   => 'https://github.com/enkessler/cuke_slicer'
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('', __dir__)) do
    source_controlled_files = `git ls-files -z`.split("\x0")
    source_controlled_files.keep_if { |file| file =~ %r{^(lib|testing/cucumber/features)} }
    source_controlled_files + ['README.md', 'LICENSE.txt', 'CHANGELOG.md', 'cuke_slicer.gemspec']
  end
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3', '< 4.0'

  spec.add_runtime_dependency 'cuke_modeler', '>= 3.2', '< 4.0'

  spec.add_development_dependency 'childprocess', '< 5.0'
  spec.add_development_dependency 'ffi', '< 2.0' # This is an invisible dependency for the `childprocess` gem on Windows
  spec.add_development_dependency 'bundler', '< 3.0'
  spec.add_development_dependency 'rake', '< 13.0.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'cucumber', '< 5.0.0'
  spec.add_development_dependency 'simplecov', '< 1.0.0'
  spec.add_development_dependency 'simplecov-lcov', '< 1.0'
  spec.add_development_dependency 'rainbow', '< 4.0.0'
  spec.add_development_dependency 'rubocop', '<= 0.50.0' # RuboCop can not lint against Ruby 2.0 after this version
  spec.add_development_dependency 'yard', '< 1.0'
end
