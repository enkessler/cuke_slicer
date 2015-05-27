module CukeSlicer
  class FileExtractor
    attr_accessor :target, :filters, :block

    def initialize(target, filters, &block)
      self.target = target
      self.filters = filters
      self.block = block
    end

    def extract
      Array.new.tap do |test_cases|
        unless target.feature.nil?
          tests = target.feature.tests

          runnable_elements = extract_runnable_elements(extract_runnable_block_elements(tests, filters))

          apply_custom_filter(runnable_elements, &block)

          runnable_elements.each do |element|
            test_cases << "#{element.get_ancestor(:feature_file).path}:#{element.source_line}"
          end
        end
      end
    end

    def extract_runnable_block_elements(things, filters)
      Array.new.tap do |elements|
        things.each do |thing|
          if thing.is_a?(CukeModeler::Outline)
            elements.concat(thing.examples)
          else
            elements << thing
          end
        end

        filter_excluded_paths(elements, filters[:excluded_paths])
        filter_included_paths(elements, filters[:included_paths])
        filter_excluded_tags(elements, filters[:excluded_tags])
        filter_included_tags(elements, filters[:included_tags])
      end
    end

    def extract_runnable_elements(things)
      Array.new.tap do |elements|
        things.each do |thing|
          if thing.is_a?(CukeModeler::Example)
            # Slicing in order to remove the parameter row element
            elements.concat(thing.row_elements.slice(1, thing.row_elements.count - 1))
          else
            elements << thing
          end
        end
      end
    end

    def apply_custom_filter(elements, &block)
      if block
        elements.reject! do |element|
          block.call(element)
        end
      end
    end

    def filter_excluded_tags(elements, filters)
      if filters
        filters = [filters] unless filters.is_a?(Array)

        unless filters.empty?
          elements.reject! do |element|
            matching_tag?(element, filters)
          end
        end
      end
    end

    def filter_included_tags(elements, filters)
      if filters
        filters = [filters] unless filters.is_a?(Array)

        elements.keep_if do |element|
          matching_tag?(element, filters)
        end
      end
    end

    def filter_excluded_paths(elements, filters)
      if filters
        filters = [filters] unless filters.is_a?(Array)

        elements.reject! do |element|
          matching_path?(element, filters)
        end
      end
    end

    def filter_included_paths(elements, filters)
      if filters
        filters = [filters] unless filters.is_a?(Array)

        unless filters.empty?
          elements.keep_if do |element|
            matching_path?(element, filters)
          end
        end
      end
    end

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

    def and_filter_match(element, filter)
      filter_match(element, filter)
    end

    def or_filter_match(element, filters)
      filters.any? do |filter|
        filter_match(element, filter)
      end
    end

    def filter_match(element, filter)
      if filter.is_a?(Regexp)
        element.all_tags.any? { |tag| tag =~ filter }
      else
        element.all_tags.include?(filter)
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