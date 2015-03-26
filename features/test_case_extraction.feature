Feature: Test case extraction

  Test cases can be extracted from a source file or directory and packaged in a collection
  of 'file:line' items that can then be conveniently arranged for consumption by Cucumber.


  Scenario: Extraction from a file
    Given the following feature file "a_test.feature":
      """
      Feature: A test feature

        Scenario: Test 1
          * some steps

        Scenario Outline: Test 2
          * some steps
        Examples: Block 1
          | param | value |
          | a     | 1     |
          | b     | 2     |
        Examples: Block 2
          | param | value |
          | c     | 3     |
      """
    When test cases are extracted from "a_test.feature"
    Then the following test cases are found for "a_test.feature":
      | path/to/a_test.feature:3  |
      | path/to/a_test.feature:10 |
      | path/to/a_test.feature:11 |
      | path/to/a_test.feature:14 |

  Scenario: Extraction from 'empty' files
    Given the following feature file "empty.feature":
      """
      Feature: Nothing here yet
      """
    And the following feature file "really_empty.feature":
      """
      """
    When test cases are extracted from "empty.feature"
    And test cases are extracted from "really_empty.feature"
    Then no test cases are found for "empty.feature"
    And no test cases are found for "really_empty.feature"


  Scenario: Extraction from a directory
    Given the directory "test_directory"
    And the following feature file "a_test.feature":
      """
      Feature: A test feature

        Scenario Outline: Test 1
          * some steps
        Examples:
          | param | value |
          | a     | 1     |
          | b     | 2     |
      """
    And the directory "test_directory/nested_directory"
    And the following feature file "another_test.feature":
      """
      Feature: Another test feature

        Scenario: Test 2
          * some steps
      """
    When test cases are extracted from "test_directory"
    Then the following test cases are found for "test_directory":
      | path/to/test_directory/a_test.feature:7                        |
      | path/to/test_directory/a_test.feature:8                        |
      | path/to/test_directory/nested_directory/another_test.feature:3 |

  Scenario: Extraction from 'empty' directories
    Given the directory "test_directory"
    And the following feature file "empty.feature":
      """
      Feature: WIP
      """
    And the following feature file "really_empty.feature":
      """
      """
    And the following feature file "not_a_feature.file":
      """
      Some irrelevant file.
      """
    And the directory "test_directory/empty_directory"
    When test cases are extracted from "test_directory"
    Then no test cases are found for "test_directory"
