
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

describe('Conditionals', function () {
    describe('if-statements', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.value',
            1,
            '(export value (if true 1 0))',
            'should evaluate the first expression given true'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.value',
            0,
            '(export value (if false 1 0))',
            'should evaluate the second expression given false'
        );
    });
});
