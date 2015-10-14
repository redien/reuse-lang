
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

describe('Recursion', function () {
    it_should_evaluate_expression_to_value_given_program(
        'module.factorial(10)',
        3628800,
        '(export factorial (lambda (x) (define (factorial-tail (lambda (x accumulator) (if (<= x 1) accumulator (recur (- x 1) (* accumulator x))))) (factorial-tail x 1))))'
    );
});
