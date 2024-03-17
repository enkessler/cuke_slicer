Basic stuff:
[![Gem Version](https://badge.fury.io/rb/cuke_slicer.svg)](https://rubygems.org/gems/cuke_slicer)
[![Project License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/mit-license.php)
[![Downloads](https://img.shields.io/gem/dt/cuke_slicer.svg)](https://rubygems.org/gems/cuke_slicer)

User stuff:
[![Cucumber Docs](http://img.shields.io/badge/Documentation-Features-green.svg)](https://github.com/enkessler/cuke_slicer/tree/master/testing/cucumber/features)
[![Yard Docs](http://img.shields.io/badge/Documentation-API-blue.svg)](https://www.rubydoc.info/gems/cuke_slicer)

Developer stuff:
[![Build Status](https://github.com/enkessler/cuke_slicer/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/enkessler/cuke_slicer/actions/workflows/ci.yml?query=branch%3Amaster)
[![Coverage Status](https://coveralls.io/repos/github/enkessler/cuke_slicer/badge.svg?branch=master)](https://coveralls.io/github/enkessler/cuke_slicer?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/14c5ad2f8583be273418/maintainability)](https://codeclimate.com/github/enkessler/cuke_slicer/maintainability)

---


# CukeSlicer

The cuke_slicer gem provides an easy and programmatic way to divide a Cucumber test suite into granular test
cases that can then be dealt with on an individual basis. Often this means handing them off to a distributed
testing system in order to parallelize test execution.

## Installation

Add this line to your application's Gemfile:

    gem 'cuke_slicer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cuke_slicer

## Usage

    require 'cuke_slicer'


    # Choose which part of your test suite that you want to slice up
    test_directory = 'path/to/your_test_directory'

    # Choose your slicing filters
    filters = {excluded_tags: ['@tag1','@tag2'],
               included_tags: '@tag3',
               excluded_paths: 'foo',
               included_paths: [/test_directory/]}

    # Use the slicer to find all tests matching those filters
    found_tests = CukeSlicer::Slicer.new.slice(test_directory, filters, :file_line)


    # Arrange the sliced pieces to suit your particular needs. In this case, we will dump them
    # into a file that Cucumber can consume.

    File.open('tests_to_run.txt', 'w') { |file| file.puts found_tests }

    system('cucumber @tests_to_run.txt')

In addition to tag and path filters, a block can be used for filtering tests by inspecting the 
underlying CukeModeler models that represent test cases and filtering on whatever criteria you can think up.

    CukeSlicer::Slicer.new.slice(test_directory, {}, :file_line) do |test_case|
      test_case.is_a?(CukeModeler::Scenario) &&
      test_case.get_ancestor(:feature).name =~ /first/
    end


## Development and Contributing

See [CONTRIBUTING.md](https://github.com/enkessler/cuke_slicer/blob/master/CONTRIBUTING.md)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
