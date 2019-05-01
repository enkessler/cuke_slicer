Feature: Test case extraction

  Test cases can be extracted from a source file or directory as a collection of 'file:line' items or objects that
  can then be conveniently arranged for consumption by some other tool (e.g. Cucumber).


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
    When test cases are extracted from it
    Then the following test cases are found
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
    When test cases are extracted from them
    Then no test cases are found

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
    Then the following test cases are found
      | path/to/test_directory/a_test.feature:7                        |
      | path/to/test_directory/a_test.feature:8                        |
      | path/to/test_directory/nested_directory/another_test.feature:3 |

  Scenario: Extraction from 'empty' directories
    Given the directory "test_directory"
    And the following feature file "empty.feature":
      """
      Feature: WIP
      """
    And the directory "test_directory/empty_directory"
    When test cases are extracted from "test_directory"
    Then no test cases are found

  Scenario: Extracting objects
    Given a test suite to extract from
    And the test cases are to be extracted as objects
    When test cases are extracted from it
    Then the test cases are provided as objects
