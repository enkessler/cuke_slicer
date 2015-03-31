Feature: Validation

  The slicing process will gracefully handle some of the more common problem use cases.


  Scenario: Valid filters
    * The following filter types are valid:
      | included_tags  |
      | excluded_tags  |
      | included_paths |
      | excluded_paths |

  Scenario: Using an unknown filter type
    Given a slicer
    When it tries to extract test cases using an unknown filter type
    Then an error indicating that the filter type is unknown will be triggered

  Scenario: Using an invalid filter

  Note: Filters can only be strings, regular expressions, or collections thereof.

    Given a slicer
    When it tries to extract test cases using an invalid filter
    Then an error indicating that the filter is invalid will be triggered

  Scenario: Trying to slice a non-existent file
    Given the file "a_test.feature" does not exist
    When test cases are extracted from it
    Then an error indicating that the file does not exist will be triggered

  Scenario: Trying to slice a non-existent directory
    Given the directory "test_directory" does not exist
    When test cases are extracted from it
    Then an error indicating that the directory does not exist will be triggered

  Scenario: Trying to slice an invalid feature file
    And the following feature file:
      """
      This does not look like a feature file
      """
    When test cases are extracted from it
    Then an error indicating that the feature file is invalid will be triggered

  Scenario: Non-feature files in sliced directories are ignored
    Given the directory "test_directory"
    Given the following feature file "a_test.feature":
      """
      Feature: A test feature

        Scenario: Test 1
          * some steps
      """
    And the file "not_a_feature.file"
    When test cases are extracted from "test_directory"
    Then the following test cases are found
      | path/to/test_directory/a_test.feature:3 |
