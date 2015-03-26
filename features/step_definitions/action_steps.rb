When(/^test cases are extracted from "([^"]*)"$/) do |target|
  @output ||= {}
  filters = {}

  filters[:excluded_tags] = @excluded_tag_filters if @excluded_tag_filters
  filters[:included_tags] = @included_tag_filters if @included_tag_filters
  filters[:excluded_paths] = @excluded_path_filters if @excluded_path_filters
  filters[:included_paths] = @included_path_filters if @included_path_filters

  @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", filters, &@custom_filter)
end

When(/^test cases are extracted from "([^"]*)" using the following tag filters:$/) do |target, filters|
  @output ||= {}
  options = {}

  filters.hashes.each do |filter|
    case filter['filter type']
      when 'excluded'
        options[:excluded_tags] = filter['filter']
      when 'included'
        options[:included_tags] = filter['filter']
      else
        raise("Unknown filter type #{filter['filter type']}")
    end
  end

  @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", options)
end

When(/^test cases are extracted from "([^"]*)" using the following path filters:$/) do |target, filters|
  @output ||= {}
  excluded_filters = []
  included_filters = []

  filters.hashes.each do |filter|
    case filter['filter type']
      when 'excluded'
        excluded_filters << process_filter(filter['filter'])
      when 'included'
        included_filters << process_filter(filter['filter'])
      else
        raise("Unknown filter type #{filter['filter type']}")
    end
  end


  @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", excluded_paths: excluded_filters, included_paths: included_filters)
end

When(/^test cases are extracted from "([^"]*)" using the following custom filter:$/) do |target, filter_block|
  @output ||= {}

  custom_filter = eval("Proc.new #{filter_block}")

  @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", &custom_filter)
end

When(/^test cases are extracted from "([^"]*)" using "([^"]*)"$/) do |target, included_tag_filters|
  @output ||= {}

  @output[target] = CukeSlicer::Slicer.new.slice("#{@default_file_directory}/#{target}", included_tags: included_tag_filters)
end

def process_filter(filter)
  filter.sub!('path/to', @default_file_directory)
  filter =~ /^\/.+\/$/ ? Regexp.new(filter.slice(1..-2)) : filter
end
