# CukeSlicer

<a href="http://badge.fury.io/rb/cuke_slicer"><img src="https://badge.fury.io/rb/cuke_slicer.svg" alt="Gem Version"></a>

<a href='https://gemnasium.com/grange-insurance/cuke_slicer'><img src="https://gemnasium.com/grange-insurance/cuke_slicer.svg" alt="Dependency Status" /></a>

<a href='https://github.com/grange-insurance/cuke_slicer/blob/master/LICENSE.txt'><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="Project License" /></a>

<a href="https://travis-ci.org/grange-insurance/cuke_slicer"><img src="https://travis-ci.org/grange-insurance/cuke_slicer.svg" alt="Build Status"></a>

<a href='https://coveralls.io/r/grange-insurance/cuke_slicer'><img src='https://coveralls.io/repos/grange-insurance/cuke_slicer/badge.svg' alt='Coverage Status' /></a>

<a href="https://codeclimate.com/github/grange-insurance/cuke_slicer"><img src="https://codeclimate.com/github/grange-insurance/cuke_slicer/badges/gpa.svg" alt="Code Quality" /></a>


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
