Feature: Parse errors
    As a user of reuse-lang
    I want to get parser errors
    So that I can correct my syntax

    Scenario: A missing )
        Given an expression "(+ 1 2"
        When I evaluate it
        Then I should get a translation error "Unbalanced parenthesis"
        And the error column should say 6
        And the error line should say 0

    Scenario: A missing (
        Given an expression "+ 1 2)"
        When I evaluate it
        Then I should get a translation error "Unbalanced parenthesis"
        And the error column should say 5
        And the error line should say 0
