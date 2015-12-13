
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

describe('stdlib/list.ru', function () {
    describe('list:reduce', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value(3) + module.value(39)',
            42,
            '(import stdlib/list.ru) (export value (lambda (initial-value) (list:reduce (lambda () 0) initial-value nil)))',
            'should return the initial value for an empty list'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            50,
            '(import stdlib/list.ru) (export value (lambda () (list:reduce / 100 (cons 2 nil))))',
            'should combine the first item and initial value using the provided function where the initial value is the first argument and the first item is the second'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            60,
            '(import stdlib/list.ru) (export value (lambda () (list:reduce * 1 (cons 2 (cons 3 (cons 10 nil))))))',
            'should recursively combine the first item of the list with the result of itself applied on the rest of the list'
        );
    });

    describe('list:reverse', function () {
        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            'null',
            '(import stdlib/list.ru) (export value (lambda () (list:reverse nil)))',
            'should return an empty list given an empty list'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[1,null]',
            '(import stdlib/list.ru) (export value (lambda () (list:reverse (cons 1 nil))))',
            'should return an equivalent list given a list with one item'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[2,[1,null]]',
            '(import stdlib/list.ru) (export value (lambda () (list:reverse (cons 1 (cons 2 nil)))))',
            'should swap the first two items given a list with two items'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[5,[4,[3,[2,[1,null]]]]]',
            '(import stdlib/list.ru) (export value (lambda () (list:reverse (cons 1 (cons 2 (cons 3 (cons 4 (cons 5 nil))))))))',
            'should reverse the order of all items in the list given more than 2 items'
        );
    });

    describe('list:reduce-right', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value(3) + module.value(39)',
            42,
            '(import stdlib/list.ru) (export value (lambda (initial-value) (list:reduce-right + initial-value nil)))',
            'should return the initial value for an empty list'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            50,
            '(import stdlib/list.ru) (export value (lambda () (list:reduce-right / 100 (cons 2 nil))))',
            'should combine the first item and initial value using the provided function where the initial value is the first argument and the first item is the second'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[1,[2,[3,[4,[5,null]]]]]',
            '(import stdlib/list.ru) (export value (lambda () (list:reduce-right (lambda (accumulator value) (cons value accumulator)) nil (cons 1 (cons 2 (cons 3 (cons 4 (cons 5 nil))))))))',
            'should recursively combine the last item of the list with the result of itself applied on the rest of the list'
        );
    });

    describe('list:map', function () {
        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            'null',
            '(import stdlib/list.ru) (export value (lambda () (list:map (lambda (x) x) nil)))',
            'should return an empty list given an empty list'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[2,null]',
            '(import stdlib/list.ru) (export value (lambda () (list:map (lambda (x) (+ 1 x)) (cons 1 nil))))',
            'should return a list with the first list value combined with the provided function given a list with one item'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[3,[6,[9,[12,null]]]]',
            '(import stdlib/list.ru) (export value (lambda () (list:map (lambda (x) (* 3 x)) (cons 1 (cons 2 (cons 3 (cons 4 nil)))))))',
            'should return a list with the function applied to all items in the provided list if it has more than one item'
        );
    });

    describe('list:filter', function () {
        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            'null',
            '(import stdlib/list.ru) (export value (lambda () (list:filter (lambda (x) true) nil)))',
            'should return an empty list given an empty list'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[1,null]',
            '(import stdlib/list.ru) (export value (lambda () (list:filter (lambda (x) true) (cons 1 nil))))',
            'should given a list with one item and the predicate returns true, return a list with the single item'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            'null',
            '(import stdlib/list.ru) (export value (lambda () (list:filter (lambda (x) false) (cons 1 nil))))',
            'should given a list with one item and the predicate returns false, return an empty list'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[2,[4,null]]',
            '(import stdlib/list.ru) (export value (lambda () (list:filter (lambda (x) (== (% x 2) 0)) (cons 1 (cons 2 (cons 3 (cons 4 nil)))))))',
            'should filter away items given a predicate that selects only a few items from the list'
        );
    });

    describe('list:count', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            0,
            '(import stdlib/list.ru) (export value (lambda () (list:count nil)))',
            'should return 0 given nil'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            1,
            '(import stdlib/list.ru) (export value (lambda () (list:count (cons 1 nil))))',
            'should return 1 given a list with one item'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            4,
            '(import stdlib/list.ru) (export value (lambda () (list:count (cons 1 (cons 2 (cons 3 (cons 4 nil)))))))',
            'should return n given a list with n items'
        );
    });

    describe('list:take', function () {
        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            'null',
            '(import stdlib/list.ru) (export value (lambda () (list:take nil 0)))',
            'should return nil taking 0'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[1,null]',
            '(import stdlib/list.ru) (export value (lambda () (list:take (cons 1 nil) 1)))',
            'should return an identical list taking 1 from a list with one item'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[1,null]',
            '(import stdlib/list.ru) (export value (lambda () (list:take (cons 1 (cons 2 nil)) 1)))',
            'should return a list with the first item taking 1 from a list with two items'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[1,[2,null]]',
            '(import stdlib/list.ru) (export value (lambda () (list:take (cons 1 (cons 2 nil)) 2)))',
            'should return an identical list taking n items from a list with n items'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[1,[2,null]]',
            '(import stdlib/list.ru) (export value (lambda () (list:take (cons 1 (cons 2 (cons 3 nil))) 2)))',
            'should return a list with the first n items taking n items from a list with n+k items'
        );
    });

    describe('list:take-last', function () {
        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            'null',
            '(import stdlib/list.ru) (export value (lambda () (list:take-last nil 0)))',
            'should return nil taking 0'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[1,null]',
            '(import stdlib/list.ru) (export value (lambda () (list:take-last (cons 1 nil) 1)))',
            'should return an identical list taking 1 from a list with one item'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[2,null]',
            '(import stdlib/list.ru) (export value (lambda () (list:take-last (cons 1 (cons 2 nil)) 1)))',
            'should return a list with the last item taking 1 from a list with two items'
        );


        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[2,[3,null]]',
            '(import stdlib/list.ru) (export value (lambda () (list:take-last (cons 1 (cons 2 (cons 3 nil))) 2)))',
            'should return a list with the last n items taking n items from a list with n+k items'
        );
    });

    describe('list:concatenate', function () {
        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            'null',
            '(import stdlib/list.ru) (export value (lambda () (list:concatenate nil nil)))',
            'should return nil given two empty lists'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[1,[2,null]]',
            '(import stdlib/list.ru) (export value (lambda () (list:concatenate (cons 1 (cons 2 nil)) nil)))',
            'should return the first list given an empty list as the second'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[1,[2,null]]',
            '(import stdlib/list.ru) (export value (lambda () (list:concatenate nil (cons 1 (cons 2 nil)))))',
            'should return the second list given an empty list as the first'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.value())',
            '[1,[2,[3,[4,null]]]]',
            '(import stdlib/list.ru) (export value (lambda () (list:concatenate (cons 1 (cons 2 nil)) (cons 3 (cons 4 nil)))))',
            'should return a combined list with the items of the first list, first and the second list, second given two non-empty lists'
        );
    });
});
