require "cuke_slicer/helpers/helpers"


module CukeSlicer
  class PathCollection

    include Helpers


    def initialize filter_values
      self.filter_values = filter_values
    end

    def validate
      filter_values.each do |val|
        raise(ArgumentError, "Filter '#{val}' must be a String or Regexp. Got #{val.class}") unless str_regex?(val)
      end
    end


    private

    attr_accessor :filter_values

  end
end
