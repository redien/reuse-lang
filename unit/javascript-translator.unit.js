
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
var translator = require('../lib/javascript-translator/translator');
var ast = require('../lib/ast-builder');
var definitionImporter = require('../lib/definition-importer');

var it_should_translate_from_to = function(text, from, to) {
    it(text, function () {
        checkTranslation(from, to);
    });
};

var dummyExportsForModule = function (moduleName, exports) {
    var program = ast([]);
    exports.forEach(function (name) {
        ast.push(program, ast(['export', name, '1']));
    });
    return program;
};

var checkTranslation = function (from, to) {
    var imported = definitionImporter.import(from, function (moduleName) {
        if (moduleName === 'stdlib/vector.ru') {
            return dummyExportsForModule(moduleName, [
                'vector:new',
                'vector:length',
                'vector:push',
                'vector:pop',
                'vector:element-at-index',
                'vector:last-element'
            ]);
        } else if (moduleName === 'stdlib/string.ru') {
            return dummyExportsForModule(moduleName, [
                'string:new',
                'string:length',
                'string:push',
                'string:code-point-at-index',
                'string:concatenate',
                'string:substring',
                'string:equal?'
            ]);
        }
    });
    var result = translator.translate(imported);
    if (translator.isError(result)) { throw new Error(translator.errorType(result)); }
    translator.value(result)
        .match(/\n(.+)$/)[1] // Only compare the last line.
        .should.equal(to);
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

    describe('Let-expression', function () {
        it_should_translate_from_to(
            'define a variable in an expression',
            ast([['export', 'f', ['lambda', ['x'], ['let', ['a', 'x'], 'a']]]]),
            'var f = (function (x) { return (function (a) { return a; })(x); }); module.exports.f = f;'
        );
    });

    describe('Symbol encoding', function () {
        it_should_translate_from_to(
            'encode symbols of any number of unicode characters',
            ast([['export', 'f', ['lambda', ['x'], ['let', ['金魚', 'x'], '金魚']]]]),
            'var f = (function (x) { return (function (_37329_39770) { return _37329_39770; })(x); }); module.exports.f = f;'
        );

        it_should_translate_from_to(
            'encode digits as well to avoid ambiguity in the encoding',
            ast([['export', 'f', ['lambda', ['x'], ['let', ['a123', 'x'], 'a123']]]]),
            'var f = (function (x) { return (function (a_49_50_51) { return a_49_50_51; })(x); }); module.exports.f = f;'
        );

        it_should_translate_from_to(
            'not encode numbers',
            ast([['export', 'f', ['lambda', [], ['let', ['abc', '123'], 'abc']]]]),
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
        });

        describe('Defines from imports', function () {
            it_should_translate_from_to(
                'should define symbols locally in the module using the define-from-import statement',
                ast([['define-from-import', 'abc', '123', 'module']]),
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
            'var f = (function () { return (function (vector) { return vector.push(1), vector; })([].slice()); });'
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

    describe('stdlib/string.ru', function () {
        it_should_translate_from_to(
            "should translate (string:new) to ''",
            ast([['import', 'stdlib/string.ru'], ['define', 'f', ['lambda', [], ['string:new']]]]),
            "var f = (function () { return ''; });"
        );

        it_should_translate_from_to(
            "should translate (string:length string) to string.length",
            ast([['import', 'stdlib/string.ru'], ['define', 'f', ['lambda', [], ['string:length', ['string:new']]]]]),
            "var f = (function () { return ''.length; });"
        );

        it_should_translate_from_to(
            "should translate (string:push string 1) to (string + String.fromCharCode(1))",
            ast([['import', 'stdlib/string.ru'], ['define', 'f', ['lambda', [], ['string:push', ['string:new'], '1']]]]),
            "var f = (function () { return ('' + String.fromCharCode(1)); });"
        );

        it_should_translate_from_to(
            "should translate (string:code-point-at-index string 0) to _charCodeAt(string, 0)",
            ast([['import', 'stdlib/string.ru'], ['define', 'f', ['lambda', [], ['string:code-point-at-index', ['string:new'], '0']]]]),
            "var f = (function () { return _charCodeAt('', 0); });"
        );

        it_should_translate_from_to(
            "should translate (string:substring string 1 2) to string.substr(1, 2)",
            ast([['import', 'stdlib/string.ru'], ['define', 'f', ['lambda', [], ['string:substring', ['string:new'], '1', '2']]]]),
            "var f = (function () { return ''.substr(1, 2); });"
        );

        it_should_translate_from_to(
            "should translate (string:equal? a b) to (a === b)",
            ast([['import', 'stdlib/string.ru'], ['define', 'f', ['lambda', [], ['string:equal?', ['string:new'], ['string:new']]]]]),
            "var f = (function () { return ('' === ''); });"
        );
    });
});
