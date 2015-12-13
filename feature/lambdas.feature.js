
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

describe('Lambdas', function () {
    it_should_evaluate_expression_to_value_given_program(
        'module.identity(3)',
        3,
        '(export identity (lambda (x) x))'
    );

    describe('comp', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            42,
            '(export value (lambda () ((comp (lambda (x) x) (lambda (x) x)) 42)))',
            'should return the identity function given two identity functions'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            43,
            '(export value (lambda () ((comp (lambda (x) x) (lambda (x) (+ x 1))) 42)))',
            'should return the second function given one identity function and another function'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            86,
            '(export value (lambda () ((comp (lambda (x) (* x 2)) (lambda (x) (+ x 1))) 42)))',
            'should return the two functions combined as a(b(x)) given two functions other than the identity function'
        );
    });
});
