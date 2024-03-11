require 'childprocess'


module CukeSlicer

  # Various helper methods for the project
  module CukeSlicerHelper

    module_function

    def major_version_of(gem_name)
      version_of(gem_name)[0]
    end

    def version_of(gem_name)
      major, minor, patch = Gem.loaded_specs[gem_name].version.version.match(/^(\d+)\.(\d+)\.(\d+)/)[1..3].map(&:to_i)

      [major, minor, patch]
    end

    def run_command(parts)
      parts.unshift('cmd.exe', '/c') if ChildProcess.windows?
      process = ChildProcess.build(*parts)

      process.io.inherit!
      process.start
      process.wait

      process
    end

  end
end
