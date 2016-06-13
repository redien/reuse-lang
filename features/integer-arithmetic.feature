
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
