Feature: Mathematical functions
    As a user of reuse-lang
    I want to use mathematical functions
    So that I can perform more advanced mathematical calculations

    Scenario Outline: Binary functions
        Given an expression "(<function> <a> <b>)"
        When I evaluate it
        Then I should get "<result>"

        Examples:
            | function |  a  |  b  | result |
            |    max   |  0  |  1  |    1   |
            |    max   |  1  |  0  |    1   |
            |    max   |  0  |  0  |    0   |
            |    min   |  0  |  1  |    0   |
            |    min   |  1  |  0  |    0   |
            |    min   |  0  |  0  |    0   |
