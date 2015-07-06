module CukeSlicer
  module ExtractionHelpers

    include FilterHelpers


    def extract_runnable_block_elements(things, filters, &block)
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

        apply_custom_filter(elements, &block)
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

  end
end
