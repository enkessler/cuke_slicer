require 'simplecov'
SimpleCov.command_name('cuke_slicer-cucumber_tests')


require 'cuke_slicer'


Before do
  feature_directory = "#{File.dirname(__FILE__)}/.."
  @default_file_directory = "#{feature_directory}/temp_files"
  @default_feature_file_name = 'unnamed_feature.feature'

  FileUtils.mkdir(@default_file_directory)
end

After do
  FileUtils.remove_dir(@default_file_directory, true)
end
