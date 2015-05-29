
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
var alphaConverter = require('../lib/alpha-converter');
var ast = require('../lib/ast-builder');

describe('alphaConverter', function () {
    it('should return an identical AST when no transformation is necessary', function () {
        alphaConverter.renameShadowingSymbols(
            ast(['lambda', ['y'], 'y']),
            ['x']
        ).should.match(ast(['lambda', ['y'], 'y']));
    });

    it('should not modify the original AST', function () {
        var originalAst = ast(['lambda', ['y'], 'y']);
        var convertedAst = alphaConverter.renameShadowingSymbols(
            originalAst,
            ['y']
        );

        originalAst.elements[1].elements[0].value.should.equal('y');
        originalAst.elements[2].value.should.equal('y');
    });

    it('should apply transformation x [x] -> x', function () {
        var convertedAst = alphaConverter.renameShadowingSymbols(
            ast('x'),
            ['x']
        );
        convertedAst.value.should.equal('x');
    });

    it('should apply transformation (lambda (X) X) [X] -> (lambda (Y) Y)', function () {
        var convertedAst = alphaConverter.renameShadowingSymbols(
            ast(['lambda', ['y'], 'y']),
            ['y']
        );
        convertedAst.elements[1].elements[0].value.should.not.equal('y');
        convertedAst.elements[2].value.should.not.equal('y');

        convertedAst = alphaConverter.renameShadowingSymbols(
            ast(['lambda', ['x'], 'x']),
            ['x']
        );
        convertedAst.elements[1].elements[0].value.should.not.equal('x');
        convertedAst.elements[2].value.should.not.equal('x');
    });

    it('should apply transformation (lambda (y) y) [y] -> (lambda (y2) y2)', function () {
        var convertedAst = alphaConverter.renameShadowingSymbols(
            ast(['lambda', ['x'], 'x']),
            ['x']
        );

        convertedAst.elements[1].elements[0].value.should.equal('x2');
        convertedAst.elements[2].value.should.equal('x2');
    });

    it('should apply transformation (lambda (y33) y33)) [y33] -> (lambda (y34) y34))', function () {
        var convertedAst = alphaConverter.renameShadowingSymbols(
            ast(['lambda', ['x33'], 'x33']),
            ['x33']
        );

        convertedAst.elements[1].elements[0].value.should.equal('x34');
        convertedAst.elements[2].value.should.equal('x34');
    });

    it('should apply transformation (lambda (X) (lambda (X) X)) [] -> (lambda (X) (lambda (Y) Y))', function () {
        var convertedAst = alphaConverter.renameShadowingSymbols(
            ast(['lambda', ['x'], ['lambda', ['x'], 'x']]),
            []
        );

        convertedAst.elements[1].elements[0].value.should.equal('x');
        convertedAst.elements[2].elements[1].elements[0].value.should.equal('x2');
        convertedAst.elements[2].elements[2].value.should.equal('x2');
    });

    it('should apply transformation (lambda (X) (lambda (Y) Y)) [Y] -> (lambda (X) (lambda (Z) Z))', function () {
        var convertedAst = alphaConverter.renameShadowingSymbols(
            ast(['lambda', ['y'], ['lambda', ['x'], 'x']]),
            ['x']
        );

        convertedAst.elements[1].elements[0].value.should.equal('y');
        convertedAst.elements[2].elements[1].elements[0].value.should.not.equal('x');
        convertedAst.elements[2].elements[2].value.should.not.equal('x');

        convertedAst = alphaConverter.renameShadowingSymbols(
            ast(['lambda', ['x'], ['lambda', ['y'], 'y']]),
            ['y']
        );

        convertedAst.elements[1].elements[0].value.should.equal('x');
        convertedAst.elements[2].elements[1].elements[0].value.should.not.equal('y');
        convertedAst.elements[2].elements[2].value.should.not.equal('y');
    });

    it('should apply transformation (lambda (y) (lambda (y) y)) [y] -> (lambda (y2) (lambda (y3) y3))', function () {
        var convertedAst = alphaConverter.renameShadowingSymbols(
            ast(['lambda', ['x'], ['lambda', ['x'], 'x']]),
            ['x']
        );

        convertedAst.elements[1].elements[0].value.should.equal('x2');
        convertedAst.elements[2].elements[1].elements[0].value.should.equal('x3');
        convertedAst.elements[2].elements[2].value.should.equal('x3');
    });

    it('should apply transformation (lambda (Y X) X) [X] -> (lambda (Y Z) Z)', function () {
        var convertedAst = alphaConverter.renameShadowingSymbols(
            ast(['lambda', ['x', 'y'], 'y']),
            ['y']
        );
        convertedAst.elements[1].elements[0].value.should.equal('x');
        convertedAst.elements[1].elements[1].value.should.not.equal('y');
        convertedAst.elements[2].value.should.not.equal('y');
    });

    it('should apply transformation (Y (lambda (X) X)) [X] -> (Y (lambda (Z) Z))', function () {
        var convertedAst = alphaConverter.renameShadowingSymbols(
            ast(['x', ['lambda', ['y'], 'y']]),
            ['y']
        );

        convertedAst.elements[1].elements[1].elements[0].value.should.not.equal('y');
        convertedAst.elements[1].elements[2].value.should.not.equal('y');
    });

    it('should apply transformation (X (lambda (X) Y)) [X Y] -> (X (lambda (Z) Y))', function () {
        var convertedAst = alphaConverter.renameShadowingSymbols(
            ast(['x1', ['lambda', ['x1'], 'x2']]),
            ['x1', 'x2']
        );
        convertedAst.elements[0].value.should.equal('x1');
        convertedAst.elements[1].elements[1].elements[0].value.should.equal('x3');
        convertedAst.elements[1].elements[2].value.should.equal('x2');
    });

    it('should apply transformation (Y Z (lambda (X) X)) [X] -> (Y Z (lambda (A) A))', function () {
        var convertedAst = alphaConverter.renameShadowingSymbols(
            ast(['x', 'z', ['lambda', ['y'], 'y']]),
            ['y']
        );
        convertedAst.elements[2].elements[1].elements[0].value.should.not.equal('y');
        convertedAst.elements[2].elements[2].value.should.not.equal('y');
    });

    it('should apply transformation (()) [] -> (())', function () {
        var convertedAst = alphaConverter.renameShadowingSymbols(
            ast([[]]),
            []
        );

        convertedAst.elements.length.should.equal(1);
        convertedAst.elements[0].elements.length.should.equal(0);
    });
});
