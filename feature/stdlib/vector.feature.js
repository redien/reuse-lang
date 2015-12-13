
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

    describe('vector:reduce', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            42,
            '(import stdlib/vector.ru) (export value (lambda () (vector:reduce (lambda () 0) 42 (vector:new))))',
            'should return the initial value for an empty vector'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            50,
            '(import stdlib/vector.ru) (export value (lambda () (vector:reduce / 100 (vector:push (vector:new) 2))))',
            'should combine the first item and initial value using the provided function where the initial value is the first argument and the first item is the second'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            60,
            '(import stdlib/vector.ru) (export value (lambda () (vector:reduce * 1 (vector:push (vector:push (vector:push (vector:new) 2) 3) 10))))',
            'should recursively combine the first item of the vector with the result of itself applied on the rest of the vector'
        );
    });

    describe('vector:map', function () {
        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[]',
            '(import stdlib/vector.ru) (export value (lambda () (vector:map (lambda (x) x) (vector:new))))',
            'should return an empty vector given an empty vector'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[101]',
            '(import stdlib/vector.ru) (export value (lambda () (vector:map (lambda (x) (+ 1 x)) (vector:push (vector:new) 100))))',
            'should return a vector with the first item combined with the provided function given a vector with one item'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[100,101,102,103]',
            '(import stdlib/vector.ru) (export value (lambda () (vector:map (lambda (x) (+ 3 x)) (vector:push (vector:push (vector:push (vector:push (vector:new) 97) 98) 99) 100))))',
            'should return a vector with the function applied to all items in the provided vector if it has more than one item'
        );
    });

    describe('vector:filter', function () {
        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[]',
            '(import stdlib/vector.ru) (export value (lambda () (vector:filter (lambda (x) true) (vector:new))))',
            'should return an empty vector given an empty vector'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[100]',
            '(import stdlib/vector.ru) (export value (lambda () (vector:filter (lambda (x) true) (vector:push (vector:new) 100))))',
            'should given a vector with one item and the predicate returns true, return a vector with the single item'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[]',
            '(import stdlib/vector.ru) (export value (lambda () (vector:filter (lambda (x) false) (vector:push (vector:new) 100))))',
            'should given a vector with one item and the predicate returns false, return an empty vector'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[98,100]',
            '(import stdlib/vector.ru) (export value (lambda () (vector:filter (lambda (x) (== (% x 2) 0)) (vector:push (vector:push (vector:push (vector:push (vector:new) 97) 98) 99) 100))))',
            'should filter away items given a predicate that selects only a few items from the vector'
        );
    });
});
