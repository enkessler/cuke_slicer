Given(/^the following feature file(?: "([^"]*)")?:$/) do |file_name, file_text|
  @test_directory ||= @default_file_directory
  file_name ||= @default_feature_file_name

  @targets ||= []
  @targets << file_name

  File.write("#{@test_directory}/#{file_name}", file_text)
end

Given(/^the directory "([^"]*)"$/) do |directory_name|
  @test_directory = "#{@default_file_directory}/#{directory_name}"

  FileUtils.mkdir(@test_directory)
end

Given(/^the following tag filters:$/) do |filters|
  filters.hashes.each do |filter|
    case filter['filter type']
      when 'excluded'
        @excluded_tag_filters = filter['filter']
      when 'included'
        @included_tag_filters = filter['filter']
      else
        raise("Unknown filter type #{filter['filter type']}")
    end
  end
end

And(/^the following path filters:$/) do |filters|
  @excluded_path_filters = []
  @included_path_filters = []

  filters.hashes.each do |filter|
    case filter['filter type']
      when 'excluded'
        @excluded_path_filters << process_filter(filter['filter'])
      when 'included'
        @included_path_filters << process_filter(filter['filter'])
      else
        raise("Unknown filter type #{filter['filter type']}")
    end
  end
end

And(/^the following custom filter:$/) do |filter|
  @custom_filter = eval("proc #{filter}", binding, __FILE__, __LINE__)
end

Given(/^the file "([^"]*)" does not exist$/) do |file_name|
  @test_directory ||= @default_file_directory

  @targets ||= []
  @targets << file_name

  file_path = "#{@test_directory}/#{file_name}"
  FileUtils.rm_f(file_path)
end

Given(/^the directory "([^"]*)" does not exist$/) do |directory_name|
  @targets ||= []
  @targets << directory_name

  file_path = "#{@default_file_directory}/#{directory_name}"
  FileUtils.rm_rf(file_path)
end

And(/^the file "([^"]*)"$/) do |file_name|
  @test_directory ||= @default_file_directory

  @targets ||= []
  @targets << file_name

  File.write("#{@test_directory}/#{file_name}", '')
end

Given(/^a slicer$/) do
  @slicer = CukeSlicer::Slicer.new
end

And(/^the test cases are to be extracted as objects$/) do
  @output_type = :test_object
end

And(/^an invalid output option$/) do
  @output_type = :invalid_option
end

Given(/^a test suite to extract from$/) do
  @test_directory ||= @default_file_directory

  @targets ||= []
  @targets << @default_feature_file_name


  test_suite = "Feature: Test feature

                   @tag
                   Scenario: Test scenario
                     * some step"

  File.write("#{@test_directory}/#{@default_feature_file_name}", test_suite)
end
