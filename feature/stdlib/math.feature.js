
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

describe('stdlib/math.ru', function () {
    describe('math:pow', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            0,
            '(import stdlib/math.ru) (export value (lambda () (math:pow 0 0)))',
            'should return 0 given 0^0'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            1,
            '(import stdlib/math.ru) (export value (lambda () (math:pow 3 0)))',
            'should return 1 given 3^0'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            0,
            '(import stdlib/math.ru) (export value (lambda () (math:pow 0 2)))',
            'should return 0 given 0^2'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value()',
            81,
            '(import stdlib/math.ru) (export value (lambda () (math:pow 3 4)))',
            'should return 81 given 3^4'
        );
    });
});
