module CukeSlicer
  class DirectoryExtractor
    attr_accessor :target, :filters, :block

    def initialize(target, filters, &block)
      self.target = target
      self.filters = filters
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
              test_cases.concat(FileExtractor.new(CukeModeler::FeatureFile.new(entry), filters, &block).extract)
            else
              # Non-feature files are ignored
          end

        end
      end
    end
  end
end