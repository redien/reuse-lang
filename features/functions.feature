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

    Scenario: Expression with several lambdas
        Given an expression "(+ ((lambda () 1)) ((lambda () 2)))"
        When I evaluate it
        Then I should get "3"

    Scenario: Lambda expressions as arguments
        Given an expression "((lambda (x) (x)) (lambda () 4))"
        When I evaluate it
        Then I should get "4"

    Scenario: Lambdas taking lambdas taking an argument
        Given an expression "((lambda (f) (f 1)) (lambda (x) x))"
        When I evaluate it
        Then I should get "1"
