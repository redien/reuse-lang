
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
var translator = require('../lib/javascript-translator/translator');
var ast = require('../lib/ast-builder');
var serialize = require('../lib/ast-serializer');

var it_should_translate_from_to = function(text, from, to) {
    it(text, function () {
        checkTranslation(from, to);
    });
};

var intrinsics = fs.readFileSync(__dirname + '/../lib/javascript-translator/intrinsics.js').toString();

var checkTranslation = function (from, to) {
    var result = translator.translate(from);
    if (translator.isError(result)) { throw new Error(translator.errorType(result)); }
    translator.value(result).should.equal(intrinsics + to);
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
    });

    describe('Symbol encoding', function () {
        it_should_translate_from_to(
            'encode symbols of any number of unicode characters',
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

        it_should_translate_from_to(
            'encode symbols in define statements',
            ast([['define', '金魚', '1']]),
            'var _37329_39770 = 1;'
        );
    });

    describe('Statements', function () {
        describe('Exported Names', function () {
            it_should_translate_from_to(
                'should export variables matching [a-zA-Z0-9_]+',
                ast([['export', 'abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ0123456789_', '1']]),
                'var abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ_48_49_50_51_52_53_54_55_56_57_95 = 1; module.exports.abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ0123456789_ = abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTIUVWXYZ_48_49_50_51_52_53_54_55_56_57_95;'
            );

            it('should return an exported_symbol_contains_invalid_character error given a symbol with any other characters', function () {
                var result = translator.translate(
                    ast([['export', '+', '1']])
                );

                translator.errorType(result).should.equal('exported_symbol_contains_invalid_character');
                translator.errorLine(result).should.equal(1);
                translator.errorColumn(result).should.equal(9);

                result = translator.translate(
                    ast([['export', '?', '1']])
                );

                translator.errorType(result).should.equal('exported_symbol_contains_invalid_character');
                translator.errorLine(result).should.equal(1);
                translator.errorColumn(result).should.equal(9);
            });

            it('should return an exported_symbol_contains_invalid_character error with the correct column number', function () {
                var result = translator.translate(
                    ast([['export', 'a+', '1']])
                );

                translator.errorType(result).should.equal('exported_symbol_contains_invalid_character');
                translator.errorLine(result).should.equal(1);
                translator.errorColumn(result).should.equal(10);
            });
        });

        describe('Defines', function () {
            it_should_translate_from_to(
                'should define symbols locally in the module using the define statement',
                ast([['define', 'abc', '123']]),
                'var abc = 123;'
            );

            it_should_translate_from_to(
                'should define symbols locally in the module using the define statement',
                ast([['define', 'abc', '123']]),
                'var abc = 123;'
            );
        });

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
            'should implement partial tail call optimization by optimizing self-calls',
            ast([['export', 'f', ['lambda', ['a'], ['self', 'a']]]]),
            'var f = (function (a) { var self = _generate_recursive_function(arguments); while (true) { var result; result = self(a); if (result !== null && typeof result === "object" && result._reuse_isRecurValue) { continue; } break; } return result; }); module.exports.f = f;'
        );
    });

    describe('stdlib/vector.ru', function () {
        it_should_translate_from_to(
            'should translate (vector:new) into []',
            ast([['import', 'stdlib/vector.ru'], ['define', 'f', ['lambda', [], ['vector:new']]]]),
            'var f = (function () { return []; });'
        );

        it_should_translate_from_to(
            'should translate (vector:length vector) into vector.length',
            ast([['import', 'stdlib/vector.ru'], ['define', 'f', ['lambda', [], ['vector:length', ['vector:new']]]]]),
            'var f = (function () { return [].length; });'
        );

        it_should_translate_from_to(
            "should translate (vector:push vector value) into (function (vector') { return vector'.push(1), vector'; })(vector)",
            ast([['import', 'stdlib/vector.ru'], ['define', 'f', ['lambda', [], ['vector:push', ['vector:new'], '1']]]]),
            'var f = (function () { return (function (vector) { return vector.push(1), vector; })([]); });'
        );

        it_should_translate_from_to(
            "should translate (vector:pop vector) into vector.slice(0, -1)",
            ast([['import', 'stdlib/vector.ru'], ['define', 'f', ['lambda', [], ['vector:pop', ['vector:new']]]]]),
            'var f = (function () { return [].slice(0, -1); });'
        );

        it_should_translate_from_to(
            'should translate (vector:element-at-index vector index) into vector[index]',
            ast([['import', 'stdlib/vector.ru'], ['define', 'f', ['lambda', [], ['vector:element-at-index', ['vector:new'], '0']]]]),
            'var f = (function () { return [][0]; });'
        );

        it_should_translate_from_to(
            "should translate (vector:last-element vector) into (function (vector') { return vector'[vector'.length]; })(vector)",
            ast([['import', 'stdlib/vector.ru'], ['define', 'f', ['lambda', [], ['vector:last-element', ['vector:new']]]]]),
            'var f = (function () { return (function (vector) { return vector[vector.length - 1]; })([]); });'
        );

        it_should_translate_from_to(
            "should only translate function applications if the module is imported",
            ast([['define', 'f', ['lambda', [], ['vector:last-element', ['vector:new']]]]]),
            'var f = (function () { return vector_58last_45element(vector_58new()); });'
        );
    });

    describe('stringToCodePointList', function () {
        it('should return an empty vector given an empty string', function () {
            var result = translator.listToArray(translator.stringToCodePointList(''));
            result.should.have.a.lengthOf(0);
        });

        it('should return a vector with the unicode code point of the first character in the string', function () {
            var result = translator.listToArray(translator.stringToCodePointList('金'));
            result.should.have.a.property(0, 37329);
        });

        it('should return a vector with the unicode code points of all of the characters in the string', function () {
            var result = translator.listToArray(translator.stringToCodePointList('金魚魚魚'));
            result.should.have.a.property(0, 37329);
            result.should.have.a.property(1, 39770);
            result.should.have.a.property(2, 39770);
            result.should.have.a.property(3, 39770);
        });

        it('should convert all code points over 0x10000 correctly', function () {
            var result = translator.listToArray(translator.stringToCodePointList('\uD800\uDC00'));
            result.should.have.a.property(0, 65536);
        });
    });

    describe('listToArray', function () {
        it('should return an empty array given nil', function () {
            var result = translator.listToArray(null);
            result.should.be.instanceOf(Array);
            result.should.have.a.lengthOf(0);
        });

        it('should return an array with the first item in the list given a list with one item', function () {
            var result = translator.listToArray([1, null]);
            result.should.be.instanceOf(Array);
            result.should.have.a.property(0, 1);
            result.should.have.a.lengthOf(1);
        });

        it('should return an array with all items given a list with several items', function () {
            var result = translator.listToArray([1, [3, [2, null]]]);
            result.should.be.instanceOf(Array);
            result.should.have.a.lengthOf(3);
            result.should.have.a.property(0, 1);
            result.should.have.a.property(1, 3);
            result.should.have.a.property(2, 2);
        });
    });
});
