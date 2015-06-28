
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

var it_should_evaluate_expression_to_value_given_program = require('./node-tester.js');

describe('i32', function () {
    describe('Constants', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.randomInteger()',
            42,
            '(export randomInteger (lambda () 42))'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.maxValue()',
            2147483647,
            '(export maxValue (lambda () 2147483647))'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.minValue()',
            -2147483648,
            '(export minValue (lambda () -2147483648))'
        );
    });

    describe('i32-add', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.randomInteger()',
            42,
            '(export randomInteger (lambda () (i32_add 40 2)))'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.wrapAbove()',
            -2147483648,
            '(export wrapAbove (lambda () (i32_add 2147483647 1)))'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.wrapAbove()',
            2147483647,
            '(export wrapAbove (lambda () (i32_add -2147483648 -1)))'
        );
    });
});
