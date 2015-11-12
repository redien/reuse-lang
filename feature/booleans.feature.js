
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

describe('Booleans', function () {
    it_should_evaluate_expression_to_value_given_program(
        'module.value',
        true,
        '(export value true)',
        'should have a truthy constant name true'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.value',
        false,
        '(export value false)',
        'should have a falsy constant name false'
    );

    describe('and', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(export value (lambda () (and true true)))',
            'should return true given true and true'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            false,
            '(export value (lambda () (and false true)))',
            'should return false given false and true'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            false,
            '(export value (lambda () (and true false)))',
            'should return false given true and false'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            false,
            '(export value (lambda () (and false false)))',
            'should return false given false and false'
        );
    });

    describe('or', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(export value (lambda () (or true true)))',
            'should return true given true and true'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(export value (lambda () (or false true)))',
            'should return true given false and true'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(export value (lambda () (or true false)))',
            'should return true given true and false'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            false,
            '(export value (lambda () (or false false)))',
            'should return false given false and false'
        );
    });

    describe('not', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            false,
            '(export value (lambda () (not true)))',
            'should return false given true'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(export value (lambda () (not false)))',
            'should return true given false'
        );
    });
});
