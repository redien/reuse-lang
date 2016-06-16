Feature: Functions
    As a user of reuse-lang
    I want to be able to create and apply functions
    So that I can reuse my algorithms

    Scenario: Functions without arguments
        Given an expression "((lambda () 1))"
        When I evaluate it
        Then I should get "1"
