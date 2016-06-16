Feature: Functions
    As a user of reuse-lang
    I want to be able to create and apply functions
    So that I can reuse my algorithms

    Scenario: Functions without arguments
        Given an expression "((lambda () 1))"
        When I evaluate it
        Then I should get "1"

    Scenario: Functions with one argument
        Given an expression "((lambda (x) x) 1)"
        When I evaluate it
        Then I should get "1"

    Scenario: Functions with several arguments
        Given an expression "((lambda (x y z) (+ x (* y z))) 1 2 3)"
        When I evaluate it
        Then I should get "7"
