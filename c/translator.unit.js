
var should = require('should');
var translator = require('./translator');
var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var input, result;

var expressionWrapper = function (expression) {
    return `int expression() { return ${expression}; }`;
};

describe('c.translate', function () {
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
