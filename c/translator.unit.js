
var should = require('should');
var translator = require('./translator');
var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var input, result;

var expressionWrapper = function (expression) {
    return `int expression() { return ${expression}; }`;
};

describe('C translator', function () {
    describe('translate', function () {
        describe('Integer arithmetic', function () {
            it('should translate (+ a b) into a + b', function () {
                input = list(atom('+'), atom('a'), atom('b'));

                result = translator.translate(input);

                result.should.equal(expressionWrapper('a + b'));
            });

            it('should translate (+ 1 2) into 1 + 2', function () {
                input = list(atom('+'), atom('1'), atom('2'));

                result = translator.translate(input);

                result.should.equal(expressionWrapper('1 + 2'));
            });

            it('should translate (* 1 2) into 1 * 2', function () {
                input = list(atom('*'), atom('1'), atom('2'));

                result = translator.translate(input);

                result.should.equal(expressionWrapper('1 * 2'));
            });

            it('should translate (* 1 (+ 2 3)) into 1 * (2 + 3)', function () {
                input = list(atom('*'), atom('1'), list(atom('+'), atom('2'), atom('3')));

                result = translator.translate(input);

                result.should.equal(expressionWrapper('1 * (2 + 3)'));
            });

            it('should translate (* (+ 1 2) (- 3 4)) into (1 + 2) * (3 - 4)', function () {
                input = list(atom('*'), list(atom('+'), atom('1'), atom('2')), list(atom('-'), atom('3'), atom('4')));

                result = translator.translate(input);

                result.should.equal(expressionWrapper('(1 + 2) * (3 - 4)'));
            });
        });

        describe('Lambda expression', function () {
            it('should translate (lambda () a) into a C function', function () {
                input = list(atom('lambda'), list(), atom('a'));

                result = translator.translate(input);

                result.should.equal('int reuse_gen_lambda0() { return a; }\nint expression() { return reuse_gen_lambda0; }');
            });

            it('should translate (lambda (x) x) into a C function', function () {
                input = list(atom('lambda'), list(atom('x')), atom('x'));

                result = translator.translate(input);

                result.should.equal('int reuse_gen_lambda0(x) { return x; }\nint expression() { return reuse_gen_lambda0; }');
            });

            it('should translate (lambda (x y) (+ x y)) into a C function', function () {
                input = list(atom('lambda'), list(atom('x'), atom('y')), list(atom('+'), atom('x'), atom('y')));

                result = translator.translate(input);

                result.should.equal('int reuse_gen_lambda0(x, y) { return x + y; }\nint expression() { return reuse_gen_lambda0; }');
            });

            it('should translate (lambda () (+ 1 2)) into a C function', function () {
                input = list(atom('lambda'), list(), list(atom('+'), atom('1'), atom('2')));

                result = translator.translate(input);

                result.should.equal('int reuse_gen_lambda0() { return 1 + 2; }\nint expression() { return reuse_gen_lambda0; }');
            });

            it('should translate (+ ((lambda () a)) ((lambda () b))) into two C functions', function () {
                input = list(atom('+'), list(list(atom('lambda'), list(), atom('a'))), list(list(atom('lambda'), list(), atom('b'))));

                result = translator.translate(input);

                result.should.equal('int reuse_gen_lambda0() { return a; }\nint reuse_gen_lambda1() { return b; }\nint expression() { return (reuse_gen_lambda0()) + (reuse_gen_lambda1()); }');
            });
        });
    });
});
