# Internal helper module that is not part of the public API. Subject to change at any time.
# :nodoc: all
module CukeSlicer
  # private
  module ExtractionHelpers

    include FilterHelpers


    # private
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

    # private
    def extract_runnable_elements(things)
      Array.new.tap do |elements|
        things.each do |thing|
          if thing.is_a?(CukeModeler::Example)
            # Slicing in order to remove the parameter row element
            elements.concat(thing.rows.slice(1, thing.rows.count))
          else
            elements << thing
          end
        end
      end
    end

  end
end
