
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

var should = require('should');
var ast = require('../lib/ast-builder');
var translator = require('../lib/javascript-translator/translator');

var it_should_translate_from_to = function(text, from, to) {
    it(text, function () {
        checkTranslation(from, to);
    });
};

var checkTranslation = function (from, to) {
    var result = translator.translate(from);
    if (translator.isError(result)) { throw new Error(translator.errorType(result)); }
    translator.value(result)
        .match(/\n(.+)$/)[1] // Only compare the last line.
        .should.equal(to);
};

describe('Javascript translator', function () {
    describe('Variables', function () {
        it_should_translate_from_to(
            'evaluate a variable',
            ast([['define', 'identity', ['lambda', ['x'], 'x']]]),
            'var identity = (function (x) { return x; });'
        );
    });

    describe('Names', function () {
        it_should_translate_from_to(
            'evaluate a variable with another name',
            ast([['define', 'identity', ['lambda', ['y'], 'y']]]),
            'var identity = (function (y) { return y; });'
        );

        it_should_translate_from_to(
            'evaluate a variable with a longer name',
            ast([['define', 'otherName', ['lambda', ['x'], 'x']]]),
            'var otherName = (function (x) { return x; });'
        );
    });

    describe('Constants', function () {
        it_should_translate_from_to(
            'evaluate a 32-bit integer constant',
            ast([['define', 'f', ['lambda', [], '32']]]),
            'var f = (function () { return 32; });'
        );
    });

    describe('Function Application', function () {
        it_should_translate_from_to(
            'apply a function with no arguments',
            ast([['define', 'f', ['lambda', [], ['g']]]]),
            'var f = (function () { return g(); });'
        );

        it_should_translate_from_to(
            'apply a function with one argument',
            ast([['define', 'f', ['lambda', [], ['g', '11']]]]),
            'var f = (function () { return g(11); });'
        );

        it_should_translate_from_to(
            'apply a function with two arguments',
            ast([['define', 'f', ['lambda', [], ['g', '11', '12']]]]),
            'var f = (function () { return g(11, 12); });'
        );

        it_should_translate_from_to(
            'apply a lambda literal with no arguments',
            ast([['define', 'f', ['lambda', [], [['lambda', [], '1']]]]]),
            'var f = (function () { return (function () { return 1; })(); });'
        );

        it_should_translate_from_to(
            'apply a lambda literal with one argument',
            ast([['define', 'f', ['lambda', [], [['lambda', ['x'], 'x'], '1']]]]),
            'var f = (function () { return (function (x) { return x; })(1); });'
        );

        it_should_translate_from_to(
            'translate function arguments',
            ast([['define', 'f', ['lambda', [], ['g', ['lambda', ['x'], 'x']]]]]),
            'var f = (function () { return g((function (x) { return x; })); });'
        );
    });

    describe('Function Definition', function () {
        it_should_translate_from_to(
            'define a lambda literal with two arguments',
            ast([['define', 'f', ['lambda', ['a', 'b'], ['a', 'b']]]]),
            'var f = (function (a, b) { return a(b); });'
        );
    });

    describe('Let-expression', function () {
        it_should_translate_from_to(
            'define a variable in an expression',
            ast([['define', 'f', ['lambda', ['x'], ['let', ['a', 'x'], 'a']]]]),
            'var f = (function (x) { return (function (a) { return a; })(x); });'
        );
    });

    describe('Symbol encoding', function () {
        it_should_translate_from_to(
            'encode symbols of any number of unicode characters',
            ast([['define', 'f', ['lambda', ['x'], ['let', ['金魚', 'x'], '金魚']]]]),
            'var f = (function (x) { return (function (_37329_39770) { return _37329_39770; })(x); });'
        );

        it_should_translate_from_to(
            'encode digits as well to avoid ambiguity in the encoding',
            ast([['define', 'f', ['lambda', ['x'], ['let', ['a123', 'x'], 'a123']]]]),
            'var f = (function (x) { return (function (a_49_50_51) { return a_49_50_51; })(x); });'
        );

        it_should_translate_from_to(
            'not encode numbers',
            ast([['define', 'f', ['lambda', [], ['let', ['abc', '123'], 'abc']]]]),
            'var f = (function () { return (function (abc) { return abc; })(123); });'
        );

        it_should_translate_from_to(
            'encode symbols in define statements',
            ast([['define', '金魚', '1']]),
            'var _37329_39770 = 1;'
        );

        it_should_translate_from_to(
            'encode import as an identifier',
            ast([['export', 'import', '1']]),
            'var _reserved_import = 1; module.exports.import = _export(_reserved_import);'
        );
    });

    describe('Statements', function () {
        describe('Exported Names', function () {
            it_should_translate_from_to(
                'should export variables matching [a-zA-Z0-9_]+',
                ast([['export', 'abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ0123456789_', '1']]),
                'var abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ_48_49_50_51_52_53_54_55_56_57_95 = 1; module.exports.abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ0123456789_ = _export(abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ_48_49_50_51_52_53_54_55_56_57_95);'
            );

            it_should_translate_from_to(
                'should remove question marks from the end and prepend the symbol with is_',
                ast([['export', 'question?', '1']]),
                'var question_63 = 1; module.exports.is_question = _export(question_63);'
            );

            it_should_translate_from_to(
                'should encode any other character as an underscore',
                ast([['export', '=-ab#c€', '1']]),
                'var _61_45ab_35c_8364 = 1; module.exports.__ab_c_ = _export(_61_45ab_35c_8364);'
            );
        });

        describe('Defines', function () {
            it_should_translate_from_to(
                'should define symbols locally in the module using the define statement',
                ast([['define', 'abc', '123']]),
                'var abc = 123;'
            );
        });

        describe('Defines from imports', function () {
            it_should_translate_from_to(
                'should define symbols locally in the module using the define-from-import statement',
                ast([['define-from-import', 'abc', '123', 'module']]),
                'var abc = 123;'
            );
        });

        it_should_translate_from_to(
            'should strip comments from the output',
            ast([['comment', 'some', 'symbols'], ['define-from-import', 'abc', '123', 'module']]),
            'var abc = 123;'
        );

        it('should return an invalid_statement error for an invalid statement', function () {
            var result = translator.translate(
                ast([['invalid']])
            );

            translator.errorType(result).should.equal('invalid_statement');
            translator.errorLine(result).should.equal(1);
            translator.errorColumn(result).should.equal(1);
        });
    });

    describe('Recursion', function () {
        it_should_translate_from_to(
            'should implement stack-optimizating self-calls using the recur keyword',
            ast([['define', 'f', ['lambda', ['a'], ['recur', 'a']]]]),
            'var f = (function (a) { var recur = _generate_recursive_function(arguments); while (true) { var result; result = recur(a); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; });'
        );

        it_should_translate_from_to(
            'should implement ordinary recursion using the self keyword',
            ast([['define', 'f', ['lambda', ['a'], ['self', 'a']]]]),
            'var f = (function self(a) { return self(a); });'
        );
    });
});
