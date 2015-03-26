require 'simplecov'
SimpleCov.command_name('cucumber_tests')


require 'cuke_slicer'


Before('~@unit') do
  @default_file_directory = "#{File.dirname(__FILE__)}/../temp_files"

  FileUtils.mkdir(@default_file_directory)
end

After('~@unit') do
  FileUtils.remove_dir(@default_file_directory, true)
end
