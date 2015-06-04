require "cuke_slicer/helpers/extraction_helpers"
require "cuke_slicer/helpers/filter_helpers"
require "cuke_slicer/helpers/matching_helpers"


module CukeSlicer
  class FileExtractor

    include ExtractionHelpers
    include FilterHelpers
    include MatchingHelpers


    def initialize(target, filters, &block)
      self.target = target
      self.filters = filters
      self.block = block
    end

    def extract
      Array.new.tap do |test_cases|
        unless target.feature.nil?
          tests = target.feature.tests

          runnable_elements = extract_runnable_elements(extract_runnable_block_elements(tests, filters))

          apply_custom_filter(runnable_elements, &block)

          runnable_elements.each do |element|
            test_cases << "#{element.get_ancestor(:feature_file).path}:#{element.source_line}"
          end
        end
      end
    end


    private

    attr_accessor :target, :filters, :block

  end
end
