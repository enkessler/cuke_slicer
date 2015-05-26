module CukeSlicer
  class FilterSet
    attr_reader :filter_type, :filter_value

    def initialize filter_type, filter_value
      @filter_type = filter_type
      @filter_value = filter_value
    end

    def block_unknown
      raise(ArgumentError, "Unknown filter '#{filter_type}'") unless CukeSlicer::Slicer.known_filters.include?(filter_type)
    end

    def block_invalid
      raise(ArgumentError, "Invalid filter '#{filter_value}'. Must be a String, Regexp, or Array thereof. Got #{filter_value.class}") unless valid?
    end

    def valid?
      filter_value.is_a?(String) or filter_value.is_a?(Regexp) or filter_value.is_a?(Array)
    end
  end
end