Feature: Tag logic

  Tag filters can be combined to form logical filters.

  Note: All tag filters are 'inclusive' and strings for the purposes of these examples but the same
  logic notation and limitations apply for exclusive or regular expression tag filters.


  Background:
    And the following feature file "a_test.feature":
      """
      Feature:

        @a
        Scenario: test a
        @b
        Scenario: test b
        @a @b
        Scenario: test ab
        @c
        Scenario: test c
        @d
        Scenario: test d
        @c @d
        Scenario: test cd
      """

  Scenario: Single tag
    When test cases are extracted from "a_test.feature" using "@a"
    Then "path/to/a_test.feature:4, path/to/a_test.feature:8" are found for "a_test.feature"

  Scenario Outline: ANDing and ORing tags
    When test cases are extracted from "a_test.feature" using "<tag filters>"
    Then "<test cases>" are found for "a_test.feature"
  Examples:
    | tag filters | test cases                                                                   |
    | @a\|@b      | path/to/a_test.feature:4, path/to/a_test.feature:6, path/to/a_test.feature:8 |
    | @a&@b       | path/to/a_test.feature:8                                                     |

  Scenario: Complex logic
  Note: OR takes precedence and parentheses cannot be used

    When test cases are extracted from "a_test.feature" using "@a|@c&@b|@d"
    Then "path/to/a_test.feature:8, path/to/a_test.feature:14" are found for "a_test.feature"
