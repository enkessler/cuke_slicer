Basic stuff:
[![Gem Version](https://badge.fury.io/rb/cql.svg)](https://rubygems.org/gems/cuke_slicer)
[![Project License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/mit-license.php)
[![Downloads](https://img.shields.io/gem/dt/cql.svg)](https://rubygems.org/gems/cuke_slicer)

User stuff:
[![Yard Docs](http://img.shields.io/badge/Documentation-API-blue.svg)](https://www.rubydoc.info/gems/cuke_slicer)

Developer stuff:
[![Build Status](https://travis-ci.org//grange-insurance/cuke_slicer.svg?branch=dev)](https://travis-ci.org/grange-insurance/cuke_slicer)
[![Coverage Status](https://coveralls.io/repos/github/grange-insurance/cuke_slicer/badge.svg?branch=dev)](https://coveralls.io/github/grange-insurance/cuke_slicer?branch=dev)
[![Maintainability](https://codeclimate.com/github/grange-insurance/cuke_slicer/badges/gpa.svg)](https://codeclimate.com/github/grange-insurance/cuke_slicer/maintainability)

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


## Contributing

1. Fork it ( https://github.com/[my-github-username]/cuke_slicer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
