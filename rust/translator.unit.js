
var should = require('should');
var translator = require('./translator');
var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var input, result;

describe('rust translator', function () {
    describe('translate', function () {
        describe('Integer arithmetic', function () {
            it('should translate (+ a b) into a + b', function () {
                input = list(atom('+'), atom('a'), atom('b'));

                result = translator.translate(input);

                result.should.equal('a + b');
            });

            it('should translate (+ 1 2) into 1 + 2', function () {
                input = list(atom('+'), atom('1'), atom('2'));

                result = translator.translate(input);

                result.should.equal('1 + 2');
            });

            it('should translate (* 1 2) into 1 * 2', function () {
                input = list(atom('*'), atom('1'), atom('2'));

                result = translator.translate(input);

                result.should.equal('1 * 2');
            });

            it('should translate (* 1 (+ 2 3)) into 1 * (2 + 3)', function () {
                input = list(atom('*'), atom('1'), list(atom('+'), atom('2'), atom('3')));

                result = translator.translate(input);

                result.should.equal('1 * (2 + 3)');
            });

            it('should translate (* (+ 1 2) (- 3 4)) into (1 + 2) * (3 - 4)', function () {
                input = list(atom('*'), list(atom('+'), atom('1'), atom('2')), list(atom('-'), atom('3'), atom('4')));

                result = translator.translate(input);

                result.should.equal('(1 + 2) * (3 - 4)');
            });
        });

        describe('Function application', function () {
            it('should translate (f a b) into f(a, b)', function () {
                input = list(atom('f'), atom('a'), atom('b'));

                result = translator.translate(input);

                result.should.equal('f(a, b)');
            });
        });
    });
});
