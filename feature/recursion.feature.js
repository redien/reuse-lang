
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

var factorialProgram = '(export factorial (lambda (x) (let (factorial-tail (lambda (x accumulator) (if (<= x 1) accumulator (self (- x 1) (* accumulator x))))) (factorial-tail x 1))))';

describe('Recursion', function () {
    it_should_evaluate_expression_to_value_given_program(
        'module.factorial(10)',
        3628800,
        factorialProgram,
        'should allow recursive function application using the self keyword'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.value(15)',
        55,
        '(export value (lambda (x) (if (> x 10) (recur (- x 1)) (+ x (if (> x 0) (self (- x 1)) 0)))))',
        'should allow both self- and recur calls in the same function'
    );
});
