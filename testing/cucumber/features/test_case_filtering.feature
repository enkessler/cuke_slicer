Feature: Test case filtering

  The test cases that are extracted by the slicer can be narrowed down by applying various filters
  that will eliminate results. Exclusive filters will filter out any test case that matches the
  filter, whereas inclusive filters will filter out non-matching test cases. Filters can be strings,
  regular expressions, or a custom code block and they can be combined as desired.


  Background:
    Given the directory "test_directory"
    And the following feature file "a_test.feature":
      """
      @feature_tag_1
      Feature: The first feature

        @test_tag_1
        Scenario: a scenario
          * a step

        @test_tag_2
        Scenario Outline: an outline
          * a step
        @example_tag_1
        Examples: example set 1
          | param   |
          | value 1 |
        @example_tag_2
        Examples: example set 2
          | param   |
          | value 2 |
      """
    And the directory "test_directory/nested_directory"
    And the following feature file "another_test.feature":
      """
      @feature_tag_2
      Feature: The second feature

        @test_tag_3
        Scenario: another scenario
          * a step
      """
    And the following feature file "a_third_test.feature":
      """
      @feature_tag_3
      Feature: The third feature

        @test_tag_4
        Scenario Outline: another outline
          * a step
        @example_tag_3
        Examples: example set 3
          | param   |
          | value 3 |
        @example_tag_4
        Examples: example set 4
          | param   |
          | value 4 |
      """

  Scenario: Filtering by excluded tags
    When test cases are extracted from "test_directory" using the following exclusive tag filters:
      | @feature_tag_1 |
      | /example/      |
    Then the following test cases are found
      | path/to/test_directory/a_test.feature:5                         |
      | path/to/test_directory/nested_directory/another_test.feature:5  |
      | path/to/test_directory/nested_directory/a_third_test.feature:10 |
      | path/to/test_directory/nested_directory/a_third_test.feature:14 |

  Scenario: Filtering by included tags
    When test cases are extracted from "test_directory" using the following inclusive tag filters:
      | @feature_tag_1 |
      | /example/      |
    Then the following test cases are found
      | path/to/test_directory/a_test.feature:14 |
      | path/to/test_directory/a_test.feature:18 |

  Scenario: Filter by included path
    When test cases are extracted from "test_directory" using the following inclusive path filters:
      | path/to/test_directory/nested_directory/another_test.feature |
      | /third/                                                      |
    Then the following test cases are found
      | path/to/test_directory/nested_directory/another_test.feature:5  |
      | path/to/test_directory/nested_directory/a_third_test.feature:10 |
      | path/to/test_directory/nested_directory/a_third_test.feature:14 |

  Scenario: Filter by excluded path
    When test cases are extracted from "test_directory" using the following exclusive path filters:
      | path/to/test_directory/nested_directory/another_test.feature |
      | /third/                                                      |
    Then the following test cases are found
      | path/to/test_directory/a_test.feature:5  |
      | path/to/test_directory/a_test.feature:14 |
      | path/to/test_directory/a_test.feature:18 |

  Scenario: Custom filtering

  A custom filter will filter out any test case for which the provided code block evaluates to
  true. There are not separate exclusive and inclusive versions of custom filters since a negation
  can be included in the code block to achieve the same effect.

    When test cases are extracted from "test_directory" using the following custom filter:
      """
      { |test_case|
        test_case.is_a?(CukeModeler::Scenario) and
        test_case.get_ancestor(:feature).name =~ /first/
      }
      """
    Then the following test cases are found
      | path/to/test_directory/a_test.feature:14                        |
      | path/to/test_directory/a_test.feature:18                        |
      | path/to/test_directory/nested_directory/another_test.feature:5  |
      | path/to/test_directory/nested_directory/a_third_test.feature:10 |
      | path/to/test_directory/nested_directory/a_third_test.feature:14 |

  Scenario: Combining filters
    Given the following tag filters:
      | filter type | filter         |
      | included    | @feature_tag_1 |
    And the following path filters:
      | filter type | filter   |
      | excluded    | /nested/ |
    And the following custom filter:
      """
      { |test_case| test_case.is_a?(CukeModeler::Scenario) }
      """
    When test cases are extracted from "test_directory"
    Then the following test cases are found
      | path/to/test_directory/a_test.feature:14 |
      | path/to/test_directory/a_test.feature:18 |
