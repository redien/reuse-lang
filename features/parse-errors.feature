Feature: Parse errors
    As a user of reuse-lang
    I want to get parser errors
    So that I can correct my syntax

    Scenario: A missing )
        Given an expression "(+ 1 2"
        When I evaluate it
        Then I should get a translation error "Unbalanced parenthesis"

    Scenario: A missing (
        Given an expression "+ 1 2)"
        When I evaluate it
        Then I should get a translation error "Unbalanced parenthesis"
