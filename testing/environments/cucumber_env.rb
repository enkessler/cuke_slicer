ENV['CUKE_SLICER_SIMPLECOV_COMMAND_NAME'] ||= 'cucumber_tests'

require 'simplecov'
require_relative 'common_env'


require_relative '../cucumber/step_definitions/action_steps'
require_relative '../cucumber/step_definitions/setup_steps'
require_relative '../cucumber/step_definitions/verification_steps'


Before do
  @default_file_directory = CukeSlicer::FileHelper.create_directory
  @default_feature_file_name = 'unnamed_feature.feature'
end

at_exit do
  CukeSlicer::FileHelper.created_directories.each do |dir_path|
    FileUtils.remove_entry(dir_path, true)
  end
end
