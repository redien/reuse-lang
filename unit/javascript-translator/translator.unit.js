
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

var fs = require('fs');
var should = require('should');
var translator = require('../../lib/javascript-translator/translator');
var ast = require('../../lib/ast-builder');
var serialize = require('../../lib/ast-serializer');

var it_should_translate_from_to = function(text, from, to) {
    it(text, function () {
        checkTranslation(from, to);
    });
};

var intrinsics = fs.readFileSync(__dirname + '/../../lib/javascript-translator/intrinsics.js').toString();

var checkTranslation = function (from, to) {
    var result = translator.translate(from);
    if (result.error) { throw result.error; }
    result.value.should.equal(intrinsics + to);
};

describe('Javascript translator', function () {
    describe('Variables', function () {
        it_should_translate_from_to(
            'evaluate a variable',
            ast([['export', 'identity', ['lambda', ['x'], 'x']]]),
            'var identity = (function (x) { return x; }); module.exports.identity = identity;'
        );
    });

    describe('Names', function () {
        it_should_translate_from_to(
            'evaluate a variable with another name',
            ast([['export', 'identity', ['lambda', ['y'], 'y']]]),
            'var identity = (function (y) { return y; }); module.exports.identity = identity;'
        );

        it_should_translate_from_to(
            'evaluate a variable with a longer name',
            ast([['export', 'otherName', ['lambda', ['x'], 'x']]]),
            'var otherName = (function (x) { return x; }); module.exports.otherName = otherName;'
        );
    });

    describe('Constants', function () {
        it_should_translate_from_to(
            'evaluate a 32-bit integer constant',
            ast([['export', 'f', ['lambda', [], '32']]]),
            'var f = (function () { return 32; }); module.exports.f = f;'
        );
    });

    describe('Function Application', function () {
        it_should_translate_from_to(
            'apply a function with no arguments',
            ast([['export', 'f', ['lambda', [], ['g']]]]),
            'var f = (function () { return g(); }); module.exports.f = f;'
        );

        it_should_translate_from_to(
            'apply a function with one argument',
            ast([['export', 'f', ['lambda', [], ['g', '11']]]]),
            'var f = (function () { return g(11); }); module.exports.f = f;'
        );

        it_should_translate_from_to(
            'apply a function with two arguments',
            ast([['export', 'f', ['lambda', [], ['g', '11', '12']]]]),
            'var f = (function () { return g(11, 12); }); module.exports.f = f;'
        );

        it_should_translate_from_to(
            'apply a lambda literal with no arguments',
            ast([['export', 'f', ['lambda', [], [['lambda', [], '1']]]]]),
            'var f = (function () { return (function () { return 1; })(); }); module.exports.f = f;'
        );

        it_should_translate_from_to(
            'apply a lambda literal with one argument',
            ast([['export', 'f', ['lambda', [], [['lambda', ['x'], 'x'], '1']]]]),
            'var f = (function () { return (function (x) { return x; })(1); }); module.exports.f = f;'
        );

        it_should_translate_from_to(
            'translate function arguments',
            ast([['export', 'f', ['lambda', [], ['g', ['lambda', ['x'], 'x']]]]]),
            'var f = (function () { return g((function (x) { return x; })); }); module.exports.f = f;'
        );
    });

    describe('Function Definition', function () {
        it_should_translate_from_to(
            'define a lambda literal with two arguments',
            ast([['export', 'f', ['lambda', ['a', 'b'], ['a', 'b']]]]),
            'var f = (function (a, b) { return a(b); }); module.exports.f = f;'
        );
    });

    describe('Variable Definition', function () {
        it_should_translate_from_to(
            'define a variable in an expression',
            ast([['export', 'f', ['lambda', ['x'], ['define', ['a', 'x'], 'a']]]]),
            'var f = (function (x) { return (function (a) { return a; })(x); }); module.exports.f = f;'
        );

        it_should_translate_from_to(
            'define several variables in an expression',
            ast([['export', 'f', ['lambda', ['x', 'y'], ['define', ['a', 'x', 'b', 'y'], ['a', 'b']]]]]),
            'var f = (function (x, y) { return (function (a, b) { return a(b); })(x, y); }); module.exports.f = f;'
        );

        it_should_translate_from_to(
            'define symbols of any number of unicode characters',
            ast([['export', 'f', ['lambda', ['x'], ['define', ['金魚', 'x'], '金魚']]]]),
            'var f = (function (x) { return (function (_37329_39770) { return _37329_39770; })(x); }); module.exports.f = f;'
        );

        it_should_translate_from_to(
            'encode digits as well to avoid ambiguity in the encoding',
            ast([['export', 'f', ['lambda', ['x'], ['define', ['a123', 'x'], 'a123']]]]),
            'var f = (function (x) { return (function (a_49_50_51) { return a_49_50_51; })(x); }); module.exports.f = f;'
        );

        it_should_translate_from_to(
            'not encode numbers',
            ast([['export', 'f', ['lambda', [], ['define', ['abc', '123'], 'abc']]]]),
            'var f = (function () { return (function (abc) { return abc; })(123); }); module.exports.f = f;'
        );
    });

    describe('Exported Names', function () {
        it_should_translate_from_to(
            'should export variables matching [a-zA-Z0-9_]+',
            ast([['export', 'abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ0123456789_', '1']]),
            'var abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ0123456789_ = 1; module.exports.abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ0123456789_ = abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ0123456789_;'
        );

        it('should return an exported_symbol_contains_invalid_character error given a symbol with any other characters', function () {
            var result = translator.translate(
                ast([['export', '+', '1']])
            );

            result.error.message.should.equal('exported_symbol_contains_invalid_character');
            result.error.line.should.equal(1);
            result.error.column.should.equal(9);

            result = translator.translate(
                ast([['export', '?', '1']])
            );

            result.error.message.should.equal('exported_symbol_contains_invalid_character');
            result.error.line.should.equal(1);
            result.error.column.should.equal(9);
        });

        it('should return an exported_symbol_contains_invalid_character error with the correct column number', function () {
            var result = translator.translate(
                ast([['export', 'a+', '1']])
            );

            result.error.message.should.equal('exported_symbol_contains_invalid_character');
            result.error.line.should.equal(1);
            result.error.column.should.equal(10);
        });
    });

    describe('Recursion', function () {
        it_should_translate_from_to(
            'should name the exported function if the recur special form is used inside the function body',
            ast([['export', 'f', ['lambda', [], ['recur']]]]),
            'var f = (function recur() { return recur(); }); module.exports.f = f;'
        );
    });
});
