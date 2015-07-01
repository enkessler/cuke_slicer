module CukeSlicer
  class DirectoryExtractor

    def initialize(target, filters, format, &block)
      self.target = target
      self.filters = filters
      self.format = format
      self.block = block
    end

    def extract
      entries = Dir.entries(target.path)
      entries.delete '.'
      entries.delete '..'

      Array.new.tap do |test_cases|
        entries.each do |entry|
          entry = "#{target.path}/#{entry}"

          case
            when File.directory?(entry)
              self.target = CukeModeler::Directory.new(entry)
              test_cases.concat(extract)
            when entry =~ /\.feature$/
              test_cases.concat(FileExtractor.new(CukeModeler::FeatureFile.new(entry), filters, format, &block).extract)
            else
              # Non-feature files are ignored
          end

        end
      end
    end


    private

    attr_accessor :target, :filters, :format, :block

  end
end
