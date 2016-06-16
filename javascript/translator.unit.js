
var should = require('should');
var translator = require('./translator');
var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var input, result;

describe('javascript translator', function () {
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

            it('should Math.floor division results', function () {
                input = list(atom('/'), atom('a'), atom('b'));

                result = translator.translate(input);

                result.should.equal('Math.floor(a / b)');
            });
        });

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

        describe('Function application', function () {
            it('should translate (f) into f()', function () {
                input = list(atom('f'));

                result = translator.translate(input);

                result.should.equal('f()');
            });

            it('should translate (f a) into f(a)', function () {
                input = list(atom('f'), atom('a'));

                result = translator.translate(input);

                result.should.equal('f(a)');
            });

            it('should translate (f a b) into f(a, b)', function () {
                input = list(atom('f'), atom('a'), atom('b'));

                result = translator.translate(input);

                result.should.equal('f(a, b)');
            });

            it('should translate (f a b c) into f(a, b, c)', function () {
                input = list(atom('f'), atom('a'), atom('b'), atom('c'));

                result = translator.translate(input);

                result.should.equal('f(a, b, c)');
            });

            it('should translate ((f)) into f()()', function () {
                input = list(list(atom('f')));

                result = translator.translate(input);

                result.should.equal('f()()');
            });

            it('should translate (f (f)) into f(f())', function () {
                input = list(atom('f'), list(atom('f')));

                result = translator.translate(input);

                result.should.equal('f(f())');
            });
        });
    });
});
