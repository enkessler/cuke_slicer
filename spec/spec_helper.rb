require 'simplecov'
SimpleCov.command_name('cuke_slicer-rspec_tests')


require 'cuke_slicer'


RSpec.configure do |config|
  config.before(:all) do
    spec_directory = File.dirname(__FILE__)
    @default_file_directory = "#{spec_directory}/temp_files"
  end

  config.before(:each) do
    FileUtils.mkpath(@default_file_directory)
  end

  config.after(:each) do
    FileUtils.remove_dir(@default_file_directory, true)
  end

end
