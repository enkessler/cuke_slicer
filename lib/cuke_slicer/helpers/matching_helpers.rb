module CukeSlicer
  module MatchingHelpers

    def matching_tag?(element, filters)
      if filters.is_a?(Array)
        filter_match = or_filter_match(element, filters)
      else
        filters.each do |filter|
          filter_match = and_filter_match(element, filter)
        end

      end
      !!filter_match
    end

    def and_filter_match(element, filter)
      filter_match(element, filter)
    end

    def or_filter_match(element, filters)
      filters.any? do |filter|
        filter_match(element, filter)
      end
    end

    def filter_match(element, filter)
      tag_values = element.all_tags
      tag_values = tag_values.collect {|tag| tag.name} if Gem.loaded_specs['cuke_modeler'].version.version[/^1/]

      if filter.is_a?(Regexp)
        tag_values.any? {|tag| tag =~ filter}
      else
        tag_values.include?(filter)
      end
    end

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
