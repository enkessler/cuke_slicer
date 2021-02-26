Then(/^the following test cases are found$/) do |expected_test_cases|
  expected_test_cases = expected_test_cases.raw.flatten
  expected_test_cases.collect! { |test_case| test_case.sub('path/to', @default_file_directory) }

  found_test_cases = @output.values.flatten

  expect(found_test_cases).to match_array(expected_test_cases)
end

Then(/^no test cases are found$/) do
  expect(@output.values.flatten).to be_empty
end

Then(/^The following filter types are valid:$/) do |filter_types|
  filter_types = filter_types.raw.flatten.map(&:to_sym)

  expect(CukeSlicer::Slicer.known_filters).to match_array(filter_types)
end

Then(/^"([^"]*)" are found$/) do |test_cases|
  expected_test_cases = test_cases.delete(' ').split(',')
  expected_test_cases.collect! { |test_case| test_case.sub('path/to', @default_file_directory) }

  found_test_cases = @output.values.flatten

  expect(found_test_cases).to match_array(expected_test_cases)
end

Then(/^an error indicating that the (?:file|directory) does not exist will be triggered$/) do
  expect(@error_raised).to_not be_nil
  expect(@error_raised.message).to match(/file.*directory.*does not exist/i)
end

Then(/^an error indicating that the feature file is invalid will be triggered$/) do
  expect(@error_raised).to_not be_nil
  expect(@error_raised.message).to match(/syntax.*lexing/)
end

Then(/^an error indicating that the filter type is unknown will be triggered$/) do
  expect(@error_raised).to_not be_nil
  expect(@error_raised.message).to match(/unknown filter/i)
end

Then(/^an error indicating that the filter is invalid will be triggered$/) do
  expect(@error_raised).to_not be_nil
  expect(@error_raised.message).to match(/invalid filter/i)
end

Then(/^the test cases are provided as objects$/) do
  @output.values.flatten.each do |output|
    expect(output).to be_a(CukeModeler::Scenario).or be_a(CukeModeler::Row)
  end
end

Then(/^an error indicating that the output type is invalid will be triggered$/) do
  expect(@error_raised).to_not be_nil
  expect(@error_raised.message).to match(/Invalid Output Format/i)
end
