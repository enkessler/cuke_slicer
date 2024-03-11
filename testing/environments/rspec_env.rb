ENV['CUKE_SLICER_SIMPLECOV_COMMAND_NAME'] ||= 'rspec_tests'

require 'simplecov'
require_relative 'common_env'


RSpec.configure do |config|

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end


  config.before(:each) do
    @default_file_directory = CukeSlicer::FileHelper.create_directory
  end

  config.after(:suite) do
    CukeSlicer::FileHelper.created_directories.each do |dir_path|
      FileUtils.remove_entry(dir_path, true)
    end
  end

  # Methods will be available outside of tests
  include CukeSlicer::HelperMethods
end
