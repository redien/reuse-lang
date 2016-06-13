
Feature: Integer Arithmetic
    As a user of reuse-lang
    I want to be able to evaluate math expressions
    So that I can do basic arithmetic

    Scenario: A simple expression
        Given an expression "(+ 1 2)"
        When I evaluate it
        Then I should get "3"
