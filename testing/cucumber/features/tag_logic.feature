Feature: Tag logic

  Normally, tag filters are applied using a logical AND. That is, a tag filter will trigger if a
  test case's tags match ALL of the provided tag filters. If desired, the tag filters can be
  evaluated using a logical OR and, further, the two kinds of evaluation can be combined.

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


  Scenario Outline: ANDing and ORing tags
  Tags that are grouped together will be OR'd together before the remaining AND evaluation occurs

    When test cases are extracted from "a_test.feature" using "<tag filters>"
    Then "<test cases>" are found
  Examples:
    | tag filters | test cases                                                                   |
    | '@a'        | path/to/a_test.feature:4,  path/to/a_test.feature:8                          |
    | ['@a']      | path/to/a_test.feature:4,  path/to/a_test.feature:8                          |
    | '@a','@b'   | path/to/a_test.feature:8                                                     |
    | ['@a','@b'] | path/to/a_test.feature:4, path/to/a_test.feature:6, path/to/a_test.feature:8 |

  Scenario: Complex logic
    When test cases are extracted from "a_test.feature" using "['@a','@c'],['@b','@d']"
    Then "path/to/a_test.feature:8, path/to/a_test.feature:14" are found
