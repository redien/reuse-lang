
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

describe('Integers', function () {
    it_should_evaluate_expression_to_value_given_program(
        'module.add(3, 2)',
        5,
        '(export add (lambda (a b) (i32_add a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.subtract(3, 2)',
        1,
        '(export subtract (lambda (a b) (i32_subtract a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.subtract(3, 2)',
        1,
        '(export subtract (lambda (a b) (i32_subtract a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.divide(15, 3)',
        5,
        '(export divide (lambda (a b) (i32_divide a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.divide(3, 2)',
        1,
        '(export divide (lambda (a b) (i32_divide a b)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.multiply(3, 2)',
        6,
        '(export multiply (lambda (a b) (i32_multiply a b)))'
    );
});
