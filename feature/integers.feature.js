
// reuse-lang - a pure functional lisp-like language for writing
// reusable algorithms in an extremely portable way.
//
// Written in 2015 by Jesper Oskarsson jesosk@gmail.com
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

var it_should_evaluate_expression_to_value_given_program = require('./util/expect-value');
var it_should_return_error_given_program = require('./util/expect-error');

describe('Integers', function () {
    it_should_evaluate_expression_to_value_given_program(
        'module.value',
        2147483647,
        '(export value 2147483647)',
        'should support integer constants up to 2147483647 inclusive'
    );

    it_should_return_error_given_program(
        'invalid_integer_constant',
        1,
        15,
        '(export value 2147483648)'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.add(3, 2)',
        5,
        '(export add (lambda (a b) (+ a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.subtract(3, 2)',
        1,
        '(export subtract (lambda (a b) (- a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.divide(15, 3)',
        5,
        '(export divide (lambda (a b) (/ a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.divide(3, 2)',
        1,
        '(export divide (lambda (a b) (/ a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.multiply(3, 2)',
        6,
        '(export multiply (lambda (a b) (* a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.modulus(11, 3)',
        2,
        '(export modulus (lambda (a b) (% a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.greaterThan(3, 2)',
        true,
        '(export greaterThan (lambda (a b) (> a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.greaterThan(2, 3)',
        false,
        '(export greaterThan (lambda (a b) (> a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.greaterThan(3, 3)',
        false,
        '(export greaterThan (lambda (a b) (> a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.lesserThan(3, 2)',
        false,
        '(export lesserThan (lambda (a b) (< a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.lesserThan(3, 3)',
        false,
        '(export lesserThan (lambda (a b) (< a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.lesserThan(2, 3)',
        true,
        '(export lesserThan (lambda (a b) (< a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.greaterThanOrEqual(3, 2)',
        true,
        '(export greaterThanOrEqual (lambda (a b) (>= a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.greaterThanOrEqual(3, 3)',
        true,
        '(export greaterThanOrEqual (lambda (a b) (>= a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.greaterThanOrEqual(2, 3)',
        false,
        '(export greaterThanOrEqual (lambda (a b) (>= a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.lesserThanOrEqual(3, 2)',
        false,
        '(export lesserThanOrEqual (lambda (a b) (<= a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.lesserThanOrEqual(3, 3)',
        true,
        '(export lesserThanOrEqual (lambda (a b) (<= a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.lesserThanOrEqual(2, 3)',
        true,
        '(export lesserThanOrEqual (lambda (a b) (<= a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.equal(3, 2)',
        false,
        '(export equal (lambda (a b) (== a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.equal(3, 3)',
        true,
        '(export equal (lambda (a b) (== a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.equal(2, 3)',
        false,
        '(export equal (lambda (a b) (== a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.equal(3, 2)',
        true,
        '(export equal (lambda (a b) (!= a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.equal(3, 3)',
        false,
        '(export equal (lambda (a b) (!= a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.equal(2, 3)',
        true,
        '(export equal (lambda (a b) (!= a b)))'
    );
});
