# Internal helper module that is not part of the public API. Subject to change at any time.
# :nodoc: all
module CukeSlicer
  # private
  module Helpers

    def str_regex?(parameter)
      parameter.is_a?(String) || parameter.is_a?(Regexp)
    end

    def str_regex_arr?(parameter)
      parameter.is_a?(String) || parameter.is_a?(Regexp) || parameter.is_a?(Array)
    end

    def tag?(parameter)
      parameter.to_s =~ /tag/
    end

    def path?(parameter)
      parameter.to_s =~ /path/
    end

  end
end
