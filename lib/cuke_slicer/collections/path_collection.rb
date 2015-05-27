module CukeSlicer
  class PathCollection
    attr_accessor :filter_values

    def initialize filter_values
      self.filter_values = filter_values
    end
    def validate
      filter_values.each do |val|
        raise(ArgumentError, "Filter '#{val}' must be a String or Regexp. Got #{val.class}") unless val.is_a?(String) or val.is_a?(Regexp)
      end
    end
  end
end