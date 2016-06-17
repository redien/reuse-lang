var Immutable = require('immutable');
var should = require('should');
var infer = require('./infer');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var type = require('./type');

describe('Type inference', function () {
    it('should return an int given an integer', function () {
        var input = atom('1');
        var scope = Immutable.Map();

        var result = infer(input, scope);

        type.stringify(result).should.equal('(constant int)');
    });

    it('should return the type of a symbol', function () {
        var input = atom('a');
        var scope = Immutable.Map();
        scope = scope.set('a', {name: 'int'});

        var result = infer(input, scope);

        type.stringify(result).should.equal('(symbol int)');
    });

    it('should return the correct type for a lambda returning an int', function () {
        var input = list(atom('lambda'), list(), atom('1'));
        var scope = Immutable.Map();

        var result = infer(input, scope);

        type.stringify(result).should.equal('(lambda (function () int) () (constant int))');
    });

    it('should return the correct type for lambdas that return other functions', function () {
        var input = list(atom('lambda'), list(), list(atom('lambda'), list(), atom('1')));
        var scope = Immutable.Map();

        var result = infer(input, scope);

        type.stringify(result).should.equal('(lambda (function () (function () int)) () (lambda (function () int) () (constant int)))');
    });

    it('should return the correct type for function applications evaluating to an int', function () {
        var input = list(atom('+'), atom('1'), atom('2'));
        var scope = Immutable.Map();

        var result = infer(input, scope);

        type.stringify(result).should.equal('(application int ((symbol (function (int int) int)) (constant int) (constant int)))');
    });

    it('should return the correct type for function applications evaluating to a function', function () {
        var input = list(list(atom('lambda'), list(), list(atom('lambda'), list(), atom('1'))));
        var scope = Immutable.Map();

        var result = infer(input, scope);

        type.stringify(result).should.equal('(application (function () int) ((lambda (function () (function () int)) () (lambda (function () int) () (constant int)))))');
    });
});
