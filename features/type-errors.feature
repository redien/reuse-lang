Feature: Type errors
    As a user of reuse-lang
    I want to get errors when I use the wrong type in an expression
    So that I can catch errors when I use a type incorrectly

    Scenario: Adding a function with an integer
        Given PENDING
        Given an expression "((lambda () (+ (lambda () 1) 2)))"
        When I evaluate it
        Then I should get a translation error "Type mismatch"
        And the expected type should be "integer"
        And the found type should be "(lambda () integer)"
        And the error expression should be "(lambda () 1)"
        And the error context should be "(+ (lambda () 1) 2)"
