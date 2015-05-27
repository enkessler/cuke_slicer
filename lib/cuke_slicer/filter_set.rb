module CukeSlicer
  class FilterSet
    attr_accessor :filter_type, :filter_value

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

    def str_regex?(parameter)
      parameter.is_a?(String) or parameter.is_a?(Regexp)
    end

    def str_regex_arr?(parameter)
      parameter.is_a?(String) or parameter.is_a?(Regexp) or parameter.is_a?(Array)
    end

    def is_tag?(parameter)
      parameter.to_s =~ /tag/
    end

    def is_path?(parameter)
      parameter.to_s =~ /path/
    end

  end
end