module CukeSlicer
  class TagCollection
    include Helpers
    attr_accessor :filter_values

    def initialize parameters
      self.filter_values = parameters
    end
    def validate
      filter_values.each do |val|
        raise(ArgumentError, "Filter '#{val}' must be a String, Regexp, or Array. Got #{val.class}") unless str_regex_arr?(val)
        NestedTagCollection.new(val).validate if val.is_a?(Array)
      end
    end
  end
end