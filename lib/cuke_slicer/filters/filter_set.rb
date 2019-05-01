require "cuke_slicer/helpers/helpers"
require "cuke_slicer/collections/tag_collection"
require "cuke_slicer/collections/path_collection"


# Internal helper module that is not part of the public API. Subject to change at any time.
# :nodoc: all
module CukeSlicer
  class FilterSet

    include Helpers


    def initialize filter_type, filter_value
      self.filter_type = filter_type
      self.filter_value = filter_value
    end

    def validate
      block_unknown
      block_invalid

      if filter_value.is_a?(Array)
        TagCollection.new(filter_value).validate if is_tag?(filter_type)
        PathCollection.new(filter_value).validate if is_path?(filter_type)
      end
    end


    private


    def block_unknown
      raise(ArgumentError, "Unknown filter '#{filter_type}'") unless CukeSlicer::Slicer.known_filters.include?(filter_type)
    end

    def block_invalid
      raise(ArgumentError, "Invalid filter '#{filter_value}'. Must be a String, Regexp, or Array thereof. Got #{filter_value.class}") unless str_regex_arr?(filter_value)
    end

    attr_accessor :filter_type, :filter_value

  end
end
