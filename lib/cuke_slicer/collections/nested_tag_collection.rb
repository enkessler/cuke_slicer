require "cuke_slicer/helpers/helpers"


# Internal helper module that is not part of the public API. Subject to change at any time.
# :nodoc: all
module CukeSlicer
  class NestedTagCollection

    include Helpers


    def initialize collection
      self.nested_collection = collection
    end

    def validate
      nested_collection.each do |element|
        raise(ArgumentError, "Tag filters cannot be nested more than one level deep.") if element.is_a?(Array)
        raise(ArgumentError, "Filter '#{element}' must be a String or Regexp. Got #{element.class}") unless str_regex?(element)
      end
    end


    private

    attr_accessor :nested_collection

  end
end
