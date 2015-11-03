
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

var it_should_evaluate_expression_to_value_given_program = require('../util/expect-value');

describe('stdlib/string.ru', function () {
    describe('string:length', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            0,
            '(import stdlib/string.ru) (export value (lambda () (string:length (string:new))))',
            'should return 0 for an empty string'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            1,
            '(import stdlib/string.ru) (export value (lambda () (string:length (string:push (string:new) 75))))',
            'should return 1 for a string with one code point'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            3,
            '(import stdlib/string.ru) (export value (lambda () (string:length (string:push (string:push (string:push (string:new) 75) 76) 77))))',
            'should return n for a string with n code points'
        );
    });

    describe('string:code-point-at-index', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            75,
            '(import stdlib/string.ru) (export value (lambda () (string:code-point-at-index (string:push (string:new) 75) 0)))',
            'should return the first code point given an index of 0'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            22,
            '(import stdlib/string.ru) (export value (lambda () (string:code-point-at-index (string:push (string:push (string:new) 33) 22) 1)))',
            'should return the second code point given an index of 1'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            33,
            '(import stdlib/string.ru) (export value (lambda () (string:code-point-at-index (string:push (string:push (string:push (string:push (string:new) 11) 22) 33) 44) 2)))',
            'should return the n-th code point given an index of n-1'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            44,
            '(import stdlib/string.ru) (export value (lambda () (string:code-point-at-index (string:push (string:push (string:new) 65536) 44) 1)))',
            'should handle unicode points 65536 and over properly'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            0,
            '(import stdlib/string.ru) (export value (lambda () (string:code-point-at-index (string:push (string:push (string:new) 65536) 44) 2)))',
            'should return 0 when the index is greater than the string length'
        );
    });

    describe('string:concatenate', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            0,
            '(import stdlib/string.ru) (export value (lambda () (string:length (string:concatenate (string:new) (string:new)))))',
            'should return an empty string given two empty strings'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(import stdlib/string.ru) (export value (lambda () (define (string (string:concatenate (string:push (string:push (string:new) 1) 2) (string:new))) (string:equal? (string:push (string:push (string:new) 1) 2) string))))',
            'should return the first string given an empty string as the second'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(import stdlib/string.ru) (export value (lambda () (define (string (string:concatenate (string:new) (string:push (string:push (string:new) 1) 2))) (string:equal? (string:push (string:push (string:new) 1) 2) string))))',
            'should return the second string given an empty string as the first'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(import stdlib/string.ru) (export value (lambda () (define (string (string:concatenate (string:push (string:push (string:new) 1) 2) (string:push (string:push (string:new) 4) 5))) (string:equal? (string:push (string:push (string:push (string:push (string:new) 1) 2) 4) 5) string))))',
            'should return a combined string with the code points of the first string, first and the second string, second given two non-empty strings'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            2,
            '(import stdlib/string.ru) (export value (lambda () (string:length (string:concatenate (string:push (string:new) 1) (string:push (string:new) 1)))))',
            'should form the resulting length from adding the lengths of the two inputs'
        );
    });

    describe('string:equal?', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(import stdlib/string.ru) (export value (lambda () (string:equal? (string:new) (string:new))))',
            'should return true given two empty strings'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            false,
            '(import stdlib/string.ru) (export value (lambda () (string:equal? (string:push (string:new) 1) (string:new))))',
            'should return false given one non-empty string and one empty'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            false,
            '(import stdlib/string.ru) (export value (lambda () (string:equal? (string:new) (string:push (string:new) 1))))',
            'should return false given one empty string and one non-empty'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(import stdlib/string.ru) (export value (lambda () (string:equal? (string:push (string:push (string:new) 1) 2) (string:push (string:push (string:new) 1) 2))))',
            'should return true given two strings with the same code points'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            false,
            '(import stdlib/string.ru) (export value (lambda () (string:equal? (string:push (string:new) 1) (string:push (string:push (string:new) 1) 2))))',
            'should return false given two strings with different lengths'
        );
    });

    describe('string:substring', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            0,
            '(import stdlib/string.ru) (export value (lambda () (string:length (string:substring (string:new) 0 0))))',
            'should return an empty string given an empty string, a start of 0 and a length of 0'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(import stdlib/string.ru) (export value (lambda () (string:equal? (string:substring (string:push (string:push (string:new) 1) 2) 0 2) (string:push (string:push (string:new) 1) 2))))',
            'should return the same string given a string with n code points, a start of 0 and a length of n'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(import stdlib/string.ru) (export value (lambda () (string:equal? (string:substring (string:push (string:push (string:new) 1) 2) 0 1) (string:push (string:new) 1))))',
            'should return a string with the first l code points given a string with n code points, a start of 0 and a length of l'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(import stdlib/string.ru) (export value (lambda () (string:equal? (string:substring (string:push (string:push (string:push (string:push (string:new) 1) 65536) 3) 4) 1 2) (string:push (string:push (string:new) 65536) 3))))',
            'should return a string with the l code points at s given a string with n code points, a start of s and a length of l'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(import stdlib/string.ru) (export value (lambda () (string:equal? (string:substring (string:push (string:push (string:new) 1) 2) 1 2) (string:push (string:new) 2))))',
            'should return a string with as many code points as possible when the end reaches past the original string length'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(import stdlib/string.ru) (export value (lambda () (string:equal? (string:substring (string:push (string:push (string:new) 1) 2) 2 1) (string:new))))',
            'should return an empty string when both the start reaches past the original string length'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            true,
            '(import stdlib/string.ru) (export value (lambda () (string:equal? (string:substring (string:push (string:push (string:new) 1) 2) 0 (- 0 1)) (string:new))))',
            'should return an empty string when length is negative'
        );
    });
});
