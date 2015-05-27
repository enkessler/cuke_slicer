module CukeSlicer
  class NestedTagCollection < FilterSet
    attr_accessor :nested_collection

    def initialize collection
      self.nested_collection = collection
    end
    def validate
      nested_collection.each do |element|
        raise(ArgumentError, "Tag filters cannot be nested more than one level deep.") if element.is_a?(Array)
        raise(ArgumentError, "Filter '#{element}' must be a String or Regexp. Got #{element.class}") unless element.is_a?(String) or element.is_a?(Regexp)
      end
    end
  end
end