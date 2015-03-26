Then(/^the following test cases are found for "([^"]*)":$/) do |target, expected_test_cases|
  expected_test_cases = expected_test_cases.raw.flatten
  expected_test_cases.collect! { |test_case| test_case.sub('path/to', @default_file_directory) }

  expect(@output[target]).to match_array(expected_test_cases)
end

Then(/^no test cases are found for "([^"]*)"$/) do |target|
  expect(@output[target]).to be_empty
end

Then(/^The following filter types are possible:$/) do |filter_types|
  filter_types = filter_types.raw.flatten.collect { |filter| filter.to_sym }

  expect(CukeSlicer::Slicer.known_filters).to match_array(filter_types)
end

Then(/^"([^"]*)" are found for "([^"]*)"$/) do |test_cases, target|
  expected_test_cases = test_cases.delete(' ').split(',')
  expected_test_cases.collect! { |test_case| test_case.sub('path/to', @default_file_directory) }

  expect(@output[target]).to match_array(expected_test_cases)
end
