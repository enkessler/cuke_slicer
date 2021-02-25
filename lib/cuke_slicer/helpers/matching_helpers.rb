# Internal helper module that is not part of the public API. Subject to change at any time.
# :nodoc: all
module CukeSlicer
  # private
  module MatchingHelpers

    # private
    def matching_tag?(element, filters)
      filters.each do |filter|
        if filter.is_a?(Array)
          filter_match = or_filter_match(element, filter)
        else
          filter_match = and_filter_match(element, filter)
        end

        return false unless filter_match
      end

      true
    end

    # private
    def and_filter_match(element, filter)
      filter_match(element, filter)
    end

    # private
    def or_filter_match(element, filters)
      filters.any? do |filter|
        filter_match(element, filter)
      end
    end

    # private
    def filter_match(element, filter)
      tag_values = element.all_tags.map(&:name)

      if filter.is_a?(Regexp)
        tag_values.any? { |tag| tag =~ filter }
      else
        tag_values.include?(filter)
      end
    end

    # private
    def matching_path?(element, filters)
      filters.any? do |filtered_path|
        if filtered_path.is_a?(Regexp)
          element.get_ancestor(:feature_file).path =~ filtered_path
        else
          element.get_ancestor(:feature_file).path == filtered_path
        end
      end
    end

  end
end
