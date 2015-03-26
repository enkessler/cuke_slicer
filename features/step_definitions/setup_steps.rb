Given(/^the following feature file "([^"]*)":$/) do |file_name, file_text|
  @test_directory ||= @default_file_directory
  file_name ||= @default_feature_file_name

  File.open("#{@test_directory}/#{file_name}", 'w') { |file| file.write(file_text) }
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
  @custom_filter = eval("Proc.new #{filter}")
end
