
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

describe('stdlib/transducers.ru', function () {
    describe('transducers:mapping', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            43,
            '(import stdlib/transducers.ru) (export value (lambda () (((transducers:mapping (lambda (x) x)) +) 1 42)))',
            'should pass the value and accumulator to the reducer unchanged given the identity function'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            44,
            '(import stdlib/transducers.ru) (export value (lambda () (((transducers:mapping (lambda (x) (+ x 1))) +) 1 42)))',
            'should apply the transform function to the value and pass it to the to the reducer'
        );
    });

    describe('transducers:filtering', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            43,
            '(import stdlib/transducers.ru) (export value (lambda () (((transducers:filtering (lambda (x) true)) +) 1 42)))',
            'should apply the reducing function on the accumulator and value given a predicate that returns true'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            1,
            '(import stdlib/transducers.ru) (export value (lambda () (((transducers:filtering (lambda (x) false)) +) 1 42)))',
            'should simply return the accumulator given a predicate that returns false'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            7,
            '(import stdlib/transducers.ru) (export value (lambda () (((transducers:filtering (lambda (x) (== x 2))) +) 5 2)))',
            'should pass in the value to the predicate'
        );
    });

    describe('transducers:overriding', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            12,
            '(import stdlib/transducers.ru) (export value (lambda () (((transducers:overriding 7) +) 5 2)))',
            'should override any value with the provided one'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[null,[5,null]]',
            '(import stdlib/transducers.ru) (export value (lambda () (((transducers:overriding nil) (lambda (accumulator value) (cons value accumulator))) (cons 5 nil) 1)))',
            'should override any value with the provided one'
        );
    });
});
