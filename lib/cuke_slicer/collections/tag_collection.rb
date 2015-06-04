require "cuke_slicer/helpers/helpers"
require "cuke_slicer/collections/nested_tag_collection"


module CukeSlicer
  class TagCollection

    include Helpers


    def initialize parameters
      self.filter_values = parameters
    end

    def validate
      filter_values.each do |val|
        raise(ArgumentError, "Filter '#{val}' must be a String, Regexp, or Array. Got #{val.class}") unless str_regex_arr?(val)
        NestedTagCollection.new(val).validate if val.is_a?(Array)
      end
    end


    private

    attr_accessor :filter_values

  end
end
