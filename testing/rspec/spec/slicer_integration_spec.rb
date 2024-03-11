require_relative '../../environments/rspec_env'


RSpec.describe 'Slicer, Integration' do

  let(:clazz) { CukeSlicer::Slicer }
  let(:slicer) { clazz.new }
  let(:test_file) { "#{@default_file_directory}/a_test.feature" }
  let(:test_file_text) do
    "Feature: Test feature

      @tag
      Scenario: Test scenario
        * some step"
  end


  before(:each) do
    File.write(test_file, test_file_text)
  end


  describe 'slicing' do

    describe 'output' do

      it 'slicing returns a collection of test source lines' do
        slice_output = slicer.slice(test_file, :file_line)

        expect(slice_output).to be_an(Array)
        expect(slice_output).to_not be_empty

        slice_output.each do |test_case|
          # Test cases come in 'file_path:line_number' format
          expect(test_case).to match(/^.+:\d+$/)
        end
      end

      it 'slicing returns a collection of test objects' do
        slice_output = slicer.slice(test_file, :test_object)

        expect(slice_output).to be_an(Array)
        expect(slice_output).to_not be_empty

        slice_output.each do |test_case|
          # Test cases come as test objects
          expect(test_case).to be_a(CukeModeler::Scenario).or be_a(CukeModeler::Row)
        end
      end

      it 'complains if told to provide output in an unknown format' do
        expect { slicer.slice(test_file, :bad_option) }.to raise_error(ArgumentError, /Invalid Output Format/)
      end

    end

    it 'can slice without being provided filters' do
      expect { slicer.slice(test_file, :file_line) }.to_not raise_error
    end

    it 'uses the custom filter, if provided' do
      expect { |test_block| slicer.slice(@default_file_directory, :file_line, &test_block) }.to yield_control
      expect { slicer.slice(@default_file_directory, :file_line) }.to_not raise_error
    end

    it 'can slice an empty feature file' do
      File.open(test_file, 'w') { |file| file.write('') }

      expect { slicer.slice(test_file, :file_line) }.to_not raise_error
    end

    it 'can slice a feature that has no tests' do
      File.open(test_file, 'w') { |file| file.write('Feature: Empty feature') }

      expect { slicer.slice(test_file, :file_line) }.to_not raise_error
    end

    # CukeModeler 1.x can't handle Rules
    it 'can slice a feature that has rules', if: cuke_modeler?(2..3) do
      file_text = 'Feature:

                     Scenario:
                       * a step

                     Rule:
                       Scenario:
                         * a step'

      File.write(test_file, file_text)

      expect(slicer.slice(test_file, :file_line)).to match_array(["#{test_file}:3", "#{test_file}:7"])
    end

    it 'can slice a directory that contains non-feature files' do
      File.open("#{@default_file_directory}/not_a_feature.file", 'w') { |file| file.write('foobar') }

      expect { slicer.slice(@default_file_directory, :file_line) }.to_not raise_error
    end


    describe 'target validation' do

      it 'complains if told to slice a non-existent location' do
        expect { slicer.slice('does/not/exist', :file_line) }.to raise_error(ArgumentError, /does not exist/)
        expect { slicer.slice(nil, :file_line) }.to raise_error(ArgumentError, /does not exist/)
      end

      it 'complains if told to slice an incorrectly formatted feature file' do
        File.open(test_file, 'w') { |file| file.write('foobar') }

        expect { slicer.slice(test_file, :file_line) }
          .to raise_error(ArgumentError, /syntax.*lexing problem.*#{test_file}/i)
      end

      it 'does not swallow unexpected exceptions while slicing' do
        begin
          CukeSlicer::HelperMethods.test_storage[:old_method] = CukeModeler::Parsing.method(:parse_text)

          # Custom error type in order to ensure that we are throwing the correct thing
          module CukeSlicer
            class TestError < StandardError
            end
          end

          # Monkey patch the parsing method to throw the error that we need for testing
          module CukeModeler
            module Parsing
              class << self
                def parse_text(*_args)
                  raise(CukeSlicer::TestError, 'something went wrong')
                end
              end
            end
          end


          File.write(test_file, 'junk text')

          expect { slicer.slice(test_file, :file_line) }.to raise_error(CukeSlicer::TestError, 'something went wrong')
        ensure
          # Making sure that our changes don't escape a test and ruin the rest of the suite
          module CukeModeler
            module Parsing
              class << self
                define_method(:parse_text, CukeSlicer::HelperMethods.test_storage[:old_method])
              end
            end
          end
        end
      end

    end

  end


  describe 'filtering' do

    it 'treats an empty filter set as if the filter were not provided' do
      filters = clazz.known_filters

      filters.each do |filter|
        not_provided = slicer.slice(test_file, :file_line)

        case
          when filter.to_s =~ /path/
            nothing_provided = slicer.slice(test_file, { filter => [] }, :file_line)
          when filter.to_s =~ /tag/
            nothing_provided = slicer.slice(test_file, { filter => [] }, :file_line)
          else
            raise(ArgumentError, "Unknown filter '#{filter}'")
        end

        expect(nothing_provided).to eq(not_provided)
        expect(nothing_provided).to_not be_empty
      end
    end

    it 'can combine any and all filters' do
      filters = clazz.known_filters

      applied_filters = { excluded_tags: '@a',
                          included_tags: /./,
                          excluded_paths: 'a',
                          included_paths: /./ }

      block_filter = eval('Proc.new { |test_case| false}')

      # A reminder to update this test if new filters are added in the future
      expect(applied_filters.keys).to match_array(filters)


      expect { @slice_output = slicer.slice(@default_file_directory, applied_filters, :file_line, &block_filter) }
        .to_not raise_error
      expect(@slice_output).to be_an(Array)
      expect(@slice_output).to_not be_empty
    end


    describe 'filter validation' do

      it 'will only accept string, regular expression, or collections thereof as path filters' do
        path_filter_types = clazz.known_filters.select { |filter| filter.to_s =~ /path/ }

        path_filter_types.each do |filter|
          expect do
            slicer.slice(@default_file_directory,
                         { filter => '@some_value' },
                         :file_line)
          end
            .to_not raise_error

          expect do
            slicer.slice(@default_file_directory,
                         { filter => /some_pattern/ },
                         :file_line)
          end
            .to_not raise_error

          expect do
            slicer.slice(@default_file_directory,
                         { filter => ['@some_value', /some_pattern/] },
                         :file_line)
          end
            .to_not raise_error

          expect do
            slicer.slice(@default_file_directory,
                         { filter => :something_else },
                         :file_line)
          end
            .to raise_error(ArgumentError, /must be a/i)

          expect do
            slicer.slice(@default_file_directory,
                         { filter => [:something_else] },
                         :file_line)
          end
            .to raise_error(ArgumentError, /must be a/i)
        end
      end

      it 'will only accept strings, regular expressions, arrays, or collections thereof as tag filters' do
        tag_filter_types = clazz.known_filters.select { |filter| filter.to_s =~ /tag/ }

        tag_filter_types.each do |filter|
          expect do
            slicer.slice(@default_file_directory,
                         { filter => '@some_value' },
                         :file_line)
          end
            .to_not raise_error

          expect do
            slicer.slice(@default_file_directory,
                         { filter => /some_pattern/ },
                         :file_line)
          end
            .to_not raise_error

          expect do
            slicer.slice(@default_file_directory,

                         { filter => ['@some_value', /some_pattern/] },
                         :file_line)
          end
            .to_not raise_error

          expect do
            slicer.slice(@default_file_directory,
                         { filter => ['@some_value', [/nested_pattern/]] },
                         :file_line)
          end
            .to_not raise_error

          expect do
            slicer.slice(@default_file_directory,
                         { filter => ['@some_value', [/nested_pattern/, :bad_value]] },
                         :file_line)
          end
            .to raise_error(ArgumentError, /must be a/i)

          expect do
            slicer.slice(@default_file_directory,
                         { filter => :something_else },
                         :file_line)
          end
            .to raise_error(ArgumentError, /must be a/i)

          expect do
            slicer.slice(@default_file_directory,
                         { filter => [:something_else] },
                         :file_line)
          end
            .to raise_error(ArgumentError, /must be a/i)
        end
      end

      it 'will only accept a single level of tag filter nesting' do
        tag_filter_types = clazz.known_filters.select { |filter| filter.to_s =~ /tag/ }

        tag_filter_types.each do |filter|
          expect do
            slicer.slice(@default_file_directory,
                         { filter => ['@some_value', [/nested_pattern/]] },
                         :file_line)
          end
            .to_not raise_error

          expect do
            slicer.slice(@default_file_directory,
                         { filter => ['@some_value', [/nested_pattern/, ['way_too_nested']]] },
                         :file_line)
          end
            .to raise_error(ArgumentError, /cannot.* nested/i)
        end
      end

      it 'complains if given an unknown filter' do
        unknown_filter_type = :unknown_filter
        options = { unknown_filter_type => 'foo' }

        expect { slicer.slice(@default_file_directory, options, :file_line) }
          .to raise_error(ArgumentError, /unknown filter.*#{unknown_filter_type}/i)
      end

    end

  end

  describe "bugs that we don't want to happen again" do


    # As a nested directory structure was being traversed for slicing, the extraction algorithm was mangling the
    # current file path such that it would sometimes attempt to search non-existent locations. Sometimes this
    # resulted in an exception and sometimes this resulted in files getting silently skipped over.


    it 'can handle a realistically nested directory structure' do
      root_directory = @default_file_directory

      # Outer 'before' hook already makes a root level feature file
      expected_tests = ["#{test_file}:4"]

      # Adding a nested directory
      nested_directory_1 = "#{root_directory}/nested_directory_1"
      FileUtils.mkpath(nested_directory_1)
      test_file = "#{nested_directory_1}/nested_file_1.feature"
      File.write(test_file, test_file_text)
      expected_tests << "#{test_file}:4"
      test_file = "#{nested_directory_1}/nested_file_2.feature"
      File.write(test_file, test_file_text)
      expected_tests << "#{test_file}:4"

      # And another one
      nested_directory_2 = "#{root_directory}/nested_directory_2"
      FileUtils.mkpath(nested_directory_2)
      test_file = "#{nested_directory_2}/nested_file_1.feature"
      File.write(test_file, test_file_text)
      expected_tests << "#{test_file}:4"
      test_file = "#{nested_directory_2}/nested_file_2.feature"
      File.write(test_file, test_file_text)
      expected_tests << "#{test_file}:4"

      # And one of them has another directory inside of it
      doubly_nested_directory = "#{nested_directory_1}/doubly_nested_directory"
      FileUtils.mkpath(doubly_nested_directory)
      test_file = "#{doubly_nested_directory}/doubly_nested_file_1.feature"
      File.write(test_file, test_file_text)
      expected_tests << "#{test_file}:4"
      test_file = "#{doubly_nested_directory}/doubly_nested_file_2.feature"
      File.write(test_file, test_file_text)
      expected_tests << "#{test_file}:4"


      # No problems, no missed files
      expect { @slice_output = slicer.slice(root_directory, :file_line) }.to_not raise_error
      expect(@slice_output).to match_array(expected_tests)
    end

  end

end
