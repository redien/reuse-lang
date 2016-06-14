
Feature: Integer Arithmetic
    As a user of reuse-lang
    I want to be able to evaluate math expressions
    So that I can do basic arithmetic

    Scenario Outline: A simple expression
        Given an expression "(<operator> <a> <b>)"
        When I evaluate it
        Then I should get "<result>"

        Examples:
            | operator |  a  |  b  | result |
            | +        |  1  |  2  | 3      |
            | +        |  1  |  3  | 4      |
            | +        |  32 |  10 | 42     |
            | *        |  1  |  2  | 2      |
            | *        |  1  |  3  | 3      |
            | *        |  32 |  10 | 320    |
            | -        |  1  |  2  | -1     |
            | -        |  1  |  3  | -2     |
            | -        |  32 |  10 | 22     |
            | /        |  1  |  2  | 0      |
            | /        |  3  |  1  | 3      |
            | /        |  32 |  10 | 3      |

    Scenario: A nested expression
        Given an expression "(+ 1 (* 2 3))"
        When I evaluate it
        Then I should get "7"

    Scenario: A doubly nested expression
        Given an expression "(+ (/ 1 2) (* 3 4))"
        When I evaluate it
        Then I should get "12"
