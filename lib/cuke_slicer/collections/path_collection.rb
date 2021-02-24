require "cuke_slicer/helpers/helpers"


# Internal helper module that is not part of the public API. Subject to change at any time.
# :nodoc: all
module CukeSlicer
  # private
  class PathCollection

    include Helpers


    def initialize filter_values
      self.filter_values = filter_values
    end

    # private
    def validate
      filter_values.each do |val|
        raise(ArgumentError, "Filter '#{val}' must be a String or Regexp. Got #{val.class}") unless str_regex?(val)
      end
    end


    private

    attr_accessor :filter_values

  end
end
