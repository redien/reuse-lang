
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

describe('Lists', function () {
    it_should_evaluate_expression_to_value_given_program(
        'JSON.stringify(module.list())',
        '[]',
        '(export list (lambda () nil))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'JSON.stringify(module.list())',
        '[1,[]]',
        '(export list (lambda () (cons 1 nil)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.list()',
        1,
        '(export list (lambda () (first (cons 1 nil))))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'JSON.stringify(module.list())',
        '[]',
        '(export list (lambda () (first nil)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'JSON.stringify(module.list())',
        '[]',
        '(export list (lambda () (rest (cons 1 nil))))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'JSON.stringify(module.list())',
        '[]',
        '(export list (lambda () (rest nil)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.list()',
        true,
        '(export list (lambda () (is_nil nil)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.list()',
        false,
        '(export list (lambda () (is_nil 1)))'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.list()',
        false,
        '(export list (lambda () (is_nil (cons 2 nil))))'
    );
});
