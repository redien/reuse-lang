
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
var it_should_return_error_given_program = require('./util/expect-error');

describe('Export', function () {
    it_should_evaluate_expression_to_value_given_program(
        'module.second',
        2,
        '(export first 1) (export second 2)',
        'should export several symbols'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.second',
        3,
        '(export first 3) (export second first)',
        'should add exported symbols to the module scope'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.second()',
        6,
        '(export first_variable 3) (define local (lambda (x) (* x first_variable))) (export second (lambda () (local 2)))',
        'should define an exported symbol such that a local function can access it'
    );
});
