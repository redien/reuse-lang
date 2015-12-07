
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

describe('Continuation passing', function () {
    it_should_evaluate_expression_to_value_given_program(
        'module.value("abc", "d", function (x) { return x; })',
        'abcd',
        '(import stdlib/string.ru)(export value (lambda (x y f) (string:concatenate x (f y))))',
        'should handle arguments to callbacks correctly'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.value("abc", "d", function (f, x) { return f(x); })',
        'abcd',
        '(import stdlib/string.ru)(export value (lambda (x y f) (f (lambda (y) (string:concatenate x y)) y)))',
        'should handle functions passed as arguments to callbacks correctly'
    );
});
