
var should = require('should');
var translator = require('./translator');
var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var input, result;

describe('javascript.translate', function () {
    describe('Lambda expression', function () {
        it('should translate (lambda () a) into (() => a)', function () {
            input = list(atom('lambda'), list(), atom('a'));

            result = translator.translate(input);

            result.should.equal('(() => a)');
        });

        it('should translate (lambda (x) x) into ((x) => x)', function () {
            input = list(atom('lambda'), list(atom('x')), atom('x'));

            result = translator.translate(input);

            result.should.equal('((x) => x)');
        });

        it('should translate (lambda (x y) (+ x y)) into ((x, y) => x + y)', function () {
            input = list(atom('lambda'), list(atom('x'), atom('y')), list(atom('+'), atom('x'), atom('y')));

            result = translator.translate(input);

            result.should.equal('((x, y) => x + y)');
        });

        it('should translate (lambda () (+ 1 2)) into (() => 1 + 2)', function () {
            input = list(atom('lambda'), list(), list(atom('+'), atom('1'), atom('2')));

            result = translator.translate(input);

            result.should.equal('(() => 1 + 2)');
        });
    });

    describe('Division operator', function () {
        it('should Math.floor division results', function () {
            input = list(atom('/'), atom('a'), atom('b'));

            result = translator.translate(input);

            result.should.equal('Math.floor(a / b)');
        });
    });
});
