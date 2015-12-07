
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

describe('stdlib/vector.ru', function () {
    describe('vector:new', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            0,
            '(import stdlib/vector.ru) (export value (lambda () (let (apply (lambda (f) (f))) (vector:length (apply vector:new)))))',
            'should be possible to pass as an argument'
        );
    });

    describe('vector:length', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            0,
            '(import stdlib/vector.ru) (export value (lambda () (vector:length (vector:new))))',
            'should return 0 for an empty vector'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            1,
            '(import stdlib/vector.ru) (export value (lambda () (vector:length (vector:push (vector:new) 42))))',
            'should return 1 for a vector with one element'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            4,
            '(import stdlib/vector.ru) (export value (lambda () (vector:length (vector:push (vector:push (vector:push (vector:push (vector:new) 42) 42) 42) 42))))',
            'should return the number of elements in the vector for vectors with more than one element'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            0,
            '(import stdlib/vector.ru) (export value (lambda () (let (apply (lambda (f v) (f v))) (apply vector:length (vector:new)))))',
            'should be possible to pass as an argument'
        );
    });

    describe('vector:element-at-index', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            42,
            '(import stdlib/vector.ru) (export value (lambda () (vector:element-at-index (vector:push (vector:new) 42) 0)))',
            'should return the first element given an index of 0'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            22,
            '(import stdlib/vector.ru) (export value (lambda () (vector:element-at-index (vector:push (vector:push (vector:new) 33) 22) 1)))',
            'should return the second element given an index of 1'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            33,
            '(import stdlib/vector.ru) (export value (lambda () (vector:element-at-index (vector:push (vector:push (vector:push (vector:push (vector:new) 11) 22) 33) 44) 2)))',
            'should return the n-th element given an index of n-1'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            1,
            '(import stdlib/vector.ru) (export value (lambda () (let (apply (lambda (f v) (f v 0))) (apply vector:element-at-index (vector:push (vector:new) 1)))))',
            'should be possible to pass as an argument'
        );
    });

    describe('vector:last-element', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            24,
            '(import stdlib/vector.ru) (export value (lambda () (vector:last-element (vector:push (vector:push (vector:new) 42) 24))))',
            'should return the last element'
        );
    });

    describe('vector:pop', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            1,
            '(import stdlib/vector.ru) (export value (lambda () (vector:length (vector:pop (vector:push (vector:push (vector:new) 42) 24)))))',
            'should return a new vector with the length subtracted by one'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            42,
            '(import stdlib/vector.ru) (export value (lambda () (vector:last-element (vector:pop (vector:push (vector:push (vector:new) 42) 24)))))',
            'should return a new vector without the last element'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            2,
            '(import stdlib/vector.ru) (export value (lambda () (let (two-element (vector:push (vector:push (vector:new) 42) 24)) (let (one-element (vector:pop two-element)) (vector:length two-element)))))',
            'should not modify the original vector'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            0,
            '(import stdlib/vector.ru) (export value (lambda () (let (apply (lambda (f v) (f v))) (vector:length (apply vector:pop (vector:push (vector:new) 1))))))',
            'should be possible to pass as an argument'
        );
    });

    describe('vector:push', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            1,
            '(import stdlib/vector.ru) (export value (lambda () (let (one-element (vector:push (vector:new) 42)) (let (two-element (vector:push one-element 24)) (vector:length one-element)))))',
            'should not modify the original vector'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            1,
            '(import stdlib/vector.ru) (export value (lambda () (let (apply (lambda (f v) (f v 1))) (vector:length (apply vector:push (vector:new))))))',
            'should be possible to pass as an argument'
        );
    });
});
