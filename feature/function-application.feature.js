
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

describe('Function Application', function () {
    it_should_evaluate_expression_to_value_given_program(
        'module.apply(1990)',
        1990,
        '(export apply (lambda (x) ((lambda (a) a) x)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.apply()',
        1111,
        '(export apply (lambda () ((lambda (f, x) (f x)) (lambda (a) a) 1111)))'
    );
});
