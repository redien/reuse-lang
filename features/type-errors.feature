Feature: Type errors
    As a user of reuse-lang
    I want to get errors when I use the wrong type in an expression
    So that I can catch errors when I use a type incorrectly

    Scenario: Adding a function with an integer
        Given PENDING
        Given an expression "(+ (lambda () 1) 2)"
        When I evaluate it
        Then I should get a translation error "Function `+` called with an argument of incorrect type. Expected `int` but got `(lambda () int)`"
        And the error column should say 3
        And the error line should say 0
