require 'childprocess'


module CukeSlicer

  # Various helper methods for the project
  module CukeSlicerHelper

    module_function

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
