
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

var it_should_translate_from_to = function(from, to) {
    it('should translate ' + serialize(from) + ' to ' + to, function () {
        checkTranslation(from, to);
    });
};

var intrinsics = fs.readFileSync(__dirname + '/../../lib/javascript-translator/intrinsics.js').toString();

var checkTranslation = function (from, to) {
    var result = translator.translate(from);
    result.value.should.equal(intrinsics + to);
};

describe('translator', function () {
    describe('Variables', function () {
        // Evaluation of variable
        it_should_translate_from_to(
            ast(['export', 'identity', ['lambda', ['x'], 'x']]),
            'module.exports.identity = (function (x) { return x; });'
        );
    });

    describe('Names', function () {
        // Evaluation of variable with another name
        it_should_translate_from_to(
            ast(['export', 'identity', ['lambda', ['y'], 'y']]),
            'module.exports.identity = (function (y) { return y; });'
        );

        it_should_translate_from_to(
            ast(['export', 'otherName', ['lambda', ['x'], 'x']]),
            'module.exports.otherName = (function (x) { return x; });'
        );
    });

    describe('Constants', function () {
        // i32 constant literal
        it_should_translate_from_to(
            ast(['export', 'f', ['lambda', [], '32']]),
            'module.exports.f = (function () { return 32; });'
        );
    });

    describe('Function Application', function () {
        // Function application with no arguments
        it_should_translate_from_to(
            ast(['export', 'f', ['lambda', [], ['g']]]),
            'module.exports.f = (function () { return g(); });'
        );

        // Function application with one argument
        it_should_translate_from_to(
            ast(['export', 'f', ['lambda', [], ['g', '11']]]),
            'module.exports.f = (function () { return g(11); });'
        );

        // Function application with two arguments
        it_should_translate_from_to(
            ast(['export', 'f', ['lambda', [], ['g', '11', '12']]]),
            'module.exports.f = (function () { return g(11, 12); });'
        );

        // Function application of lambda literal with no arguments
        it_should_translate_from_to(
            ast(['export', 'f', ['lambda', [], [['lambda', [], '1']]]]),
            'module.exports.f = (function () { return (function () { return 1; })(); });'
        );

        // Function application of lambda literal with one argument
        it_should_translate_from_to(
            ast(['export', 'f', ['lambda', [], [['lambda', ['x'], 'x'], '1']]]),
            'module.exports.f = (function () { return (function (x) { return x; })(1); });'
        );

        // Function arguments should be translated
        it_should_translate_from_to(
            ast(['export', 'f', ['lambda', [], ['g', ['lambda', ['x'], 'x']]]]),
            'module.exports.f = (function () { return g((function (x) { return x; })); });'
        );
    });
});