SimpleCov.command_name(ENV['CUKE_SLICER_SIMPLECOV_COMMAND_NAME'])

SimpleCov.start do
  root __dir__
  coverage_dir "#{ENV['CUKE_SLICER_REPORT_FOLDER']}/coverage"

  add_filter '/testing/'
  add_filter 'cuke_slicer_helper'

  #Ignore results that are older than 5 minutes
  merge_timeout 300
end
