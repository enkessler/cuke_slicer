# Internal helper module that is not part of the public API. Subject to change at any time.
# :nodoc: all
module CukeSlicer
  # private
  class DirectoryExtractor

    # private
    def extract(target, filters, format, &block)
      Array.new.tap do |test_cases|
        target.feature_files.each do |feature_file|
          test_cases.concat(FileExtractor.new.extract(feature_file, filters, format, &block))
        end

        target.directories.each do |directory|
          test_cases.concat(extract(directory, filters, format, &block))
        end
      end
    end

  end
end
