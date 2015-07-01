When(/^test cases are extracted from "([^"]*)"$/) do |target|
  @output ||= {}
  filters = {}

  filters[:excluded_tags] = @excluded_tag_filters if @excluded_tag_filters
  filters[:included_tags] = @included_tag_filters if @included_tag_filters
  filters[:excluded_paths] = @excluded_path_filters if @excluded_path_filters
  filters[:included_paths] = @included_path_filters if @included_path_filters

  @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", filters, :file_line, &@custom_filter)
end

When(/^test cases are extracted from it$/) do
  @output ||= {}
  filters = {}
  target = @targets.first
  @output_type ||= :file_line

  begin
    @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", filters, @output_type)
  rescue ArgumentError => e
    @error_raised = e
  end
end

When(/^test cases are extracted from them$/) do
  @output ||= {}
  filters = {}

  @targets.each do |target|
    @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", filters, :file_line)
  end
end

When(/^test cases are extracted from "([^"]*)" using the following exclusive tag filters:$/) do |target, filters|
  @output ||= {}
  options = {}

  options[:excluded_tags] = filters.raw.flatten.collect { |filter| process_filter(filter) }

  @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", options, :file_line)
end

When(/^test cases are extracted from "([^"]*)" using the following inclusive tag filters:$/) do |target, filters|
  @output ||= {}
  options = {}

  options[:included_tags] = filters.raw.flatten.collect { |filter| process_filter(filter) }

  @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", options, :file_line)
end

When(/^test cases are extracted from "([^"]*)" using the following inclusive path filters:$/) do |target, filters|
  @output ||= {}
  options = {}

  options[:included_paths] = filters.raw.flatten.collect { |filter| process_filter(filter) }

  @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", options, :file_line)
end

When(/^test cases are extracted from "([^"]*)" using the following exclusive path filters:$/) do |target, filters|
  @output ||= {}
  options = {}

  options[:excluded_paths] = filters.raw.flatten.collect { |filter| process_filter(filter) }

  @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", options, :file_line)
end

When(/^test cases are extracted from "([^"]*)" using the following custom filter:$/) do |target, filter_block|
  @output ||= {}

  custom_filter = eval("Proc.new #{filter_block}")

  @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", :file_line, &custom_filter)
end

When(/^test cases are extracted from "([^"]*)" using "([^"]*)"$/) do |target, included_tag_filters|
  @output ||= {}
  options = {}

  options[:included_tags] = eval("[#{included_tag_filters}]")

  @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", options, :file_line)
end

def process_filter(filter)
  filter.sub!('path/to', @default_file_directory)
  filter =~ /^\/.+\/$/ ? Regexp.new(filter.slice(1..-2)) : filter
end

When(/^it tries to extract test cases using an unknown filter type$/) do
  begin
    @slicer.slice(@default_file_directory, {unknown_filter: 'foo'}, :file_line)
  rescue ArgumentError => e
    @error_raised = e
  end
end

When(/^it tries to extract test cases using an invalid filter$/) do
  begin
    @slicer.slice(@default_file_directory, {included_tags: 7}, :file_line)
  rescue ArgumentError => e
    @error_raised = e
  end
end
