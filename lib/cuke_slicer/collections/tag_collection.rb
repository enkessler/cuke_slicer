module CukeSlicer
  class TagCollection
    attr_accessor :filter_values

    def initialize parameters
      self.filter_values = parameters
    end
    def validate
      filter_values.each do |val|
        raise(ArgumentError, "Filter '#{val}' must be a String, Regexp, or Array. Got #{val.class}") unless val.is_a?(String) or val.is_a?(Regexp) or val.is_a?(Array)
        NestedTagCollection.new(val).validate if val.is_a?(Array)
      end
    end
  end
end