
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

// This intrinsic function is used temporarily before there is type system
// to do the conversion automatically on export.

describe('String converter', function () {
    describe('code-point-list-from-string', function () {
        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.convert(""))',
            'null',
            '(export convert (lambda (x) (code-point-list-from-string x)))',
            'should convert an empty string to an empty list'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.convert("a"))',
            '[97,null]',
            '(export convert (lambda (x) (code-point-list-from-string x)))',
            'should return a list with a single character converted to a unicode code point'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.convert("abK"))',
            '[97,[98,[75,null]]]',
            '(export convert (lambda (x) (code-point-list-from-string x)))',
            'should return a list with all characters converted to unicode code points'
        );

        it_should_evaluate_expression_to_value_given_program(
            'JSON.stringify(module.convert("\uD800\uDC00"))',
            '[65536,null]',
            '(export convert (lambda (x) (code-point-list-from-string x)))',
            'should convert all code points 65536 and over correctly'
        );
    });

    describe('string-from-code-point-list', function () {
        it_should_evaluate_expression_to_value_given_program(
            'module.convert()',
            '',
            '(export convert (lambda () (string-from-code-point-list nil)))',
            'should convert an empty list to an empty string'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.convert()',
            'a',
            '(export convert (lambda () (string-from-code-point-list (cons 97 nil))))',
            'should return a string with a single character converted from a unicode code point'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.convert()',
            'abK',
            '(export convert (lambda () (string-from-code-point-list (cons 97 (cons 98 (cons 75 nil))))))',
            'should return a string with all characters converted from unicode code points'
        );

        it_should_evaluate_expression_to_value_given_program(
            'module.convert()',
            '\uD800\uDC00',
            '(export convert (lambda () (string-from-code-point-list (cons 65536 nil))))',
            'should convert all code points 65536 and over correctly'
        );
    });
});
