
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

describe('Importing modules', function () {
    it_should_evaluate_expression_to_value_given_program(
        'module.value()',
        50,
        '(import ./feature/util/test-module.ru)(export value (lambda () (add-42 8)))',
        'should import modules from the local filesystem given a relative path prepended by a dot'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.value()',
        51,
        '(import ./feature/util/test-module.ru something)(export value (lambda () (something:add-42 9)))',
        'should prepend imported symbols with the specified name followed by a colon'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.value()',
        52,
        '(import ./feature/util/test-module.ru something)(export value (lambda () (something:add-50 2)))',
        'should keep references to exported symbols consistent after they are imported'
    );

    it_should_evaluate_expression_to_value_given_program(
        'module.value()',
        44,
        '(define two 2)(import ./feature/util/test-module.ru something)(export value (lambda () (something:add-42 two)))',
        'should not redefine local symbols with local symbols from imported modules'
    );

    it_should_return_error_given_program(
        'unused_import',
        1,
        2,
        '(import stdlib/string.ru)'
    );
});
