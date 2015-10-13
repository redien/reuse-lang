
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
    result.value.should.equal(intrinsics + to);
};

describe('Javascript translator', function () {
    describe('Variables', function () {
        it_should_translate_from_to(
            'evaluate a variable',
            ast(['export', 'identity', ['lambda', ['x'], 'x']]),
            'module.exports.identity = (function (x) { return x; });'
        );
    });

    describe('Names', function () {
        it_should_translate_from_to(
            'evaluate a variable with another name',
            ast(['export', 'identity', ['lambda', ['y'], 'y']]),
            'module.exports.identity = (function (y) { return y; });'
        );

        it_should_translate_from_to(
            'evaluate a variable with a longer name',
            ast(['export', 'otherName', ['lambda', ['x'], 'x']]),
            'module.exports.otherName = (function (x) { return x; });'
        );
    });

    describe('Constants', function () {
        it_should_translate_from_to(
            'evaluate a 32-bit integer constant',
            ast(['export', 'f', ['lambda', [], '32']]),
            'module.exports.f = (function () { return 32; });'
        );
    });

    describe('Function Application', function () {
        it_should_translate_from_to(
            'apply a function with no arguments',
            ast(['export', 'f', ['lambda', [], ['g']]]),
            'module.exports.f = (function () { return g(); });'
        );

        it_should_translate_from_to(
            'apply a function with one argument',
            ast(['export', 'f', ['lambda', [], ['g', '11']]]),
            'module.exports.f = (function () { return g(11); });'
        );

        it_should_translate_from_to(
            'apply a function with two arguments',
            ast(['export', 'f', ['lambda', [], ['g', '11', '12']]]),
            'module.exports.f = (function () { return g(11, 12); });'
        );

        it_should_translate_from_to(
            'apply a lambda literal with no arguments',
            ast(['export', 'f', ['lambda', [], [['lambda', [], '1']]]]),
            'module.exports.f = (function () { return (function () { return 1; })(); });'
        );

        it_should_translate_from_to(
            'apply a lambda literal with one argument',
            ast(['export', 'f', ['lambda', [], [['lambda', ['x'], 'x'], '1']]]),
            'module.exports.f = (function () { return (function (x) { return x; })(1); });'
        );

        it_should_translate_from_to(
            'translate function arguments',
            ast(['export', 'f', ['lambda', [], ['g', ['lambda', ['x'], 'x']]]]),
            'module.exports.f = (function () { return g((function (x) { return x; })); });'
        );
    });

    describe('Function Definition', function () {
        it_should_translate_from_to(
            'define a lambda literal with two arguments',
            ast(['export', 'f', ['lambda', ['a', 'b'], ['a', 'b']]]),
            'module.exports.f = (function (a, b) { return a(b); });'
        );
    });

    describe('Variable Definition', function () {
        it_should_translate_from_to(
            'define a variable in an expression',
            ast(['export', 'f', ['lambda', ['x'], ['define', ['a', 'x'], 'a']]]),
            'module.exports.f = (function (x) { return (function (a) { return a; })(x); });'
        );
    });

    describe('Exported Names', function () {
        it_should_translate_from_to(
            'should export variables matching [a-zA-Z0-9_]+',
            ast(['export', 'abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ0123456789_', '1']),
            'module.exports.abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ0123456789_ = 1;'
        );

        it('should return an exported_symbol_contains_invalid_character error given a symbol with any other characters', function () {
            var result = translator.translate(
                ast(['export', '+', '1'])
            );

            result.error.message.should.equal('exported_symbol_contains_invalid_character');
            result.error.line.should.equal(1);
            result.error.column.should.equal(9);

            result = translator.translate(
                ast(['export', '?', '1'])
            );

            result.error.message.should.equal('exported_symbol_contains_invalid_character');
            result.error.line.should.equal(1);
            result.error.column.should.equal(9);
        });

        it('should return an exported_symbol_contains_invalid_character error with the correct column number', function () {
            var result = translator.translate(
                ast(['export', 'a+', '1'])
            );

            result.error.message.should.equal('exported_symbol_contains_invalid_character');
            result.error.line.should.equal(1);
            result.error.column.should.equal(10);
        });
    });
});
