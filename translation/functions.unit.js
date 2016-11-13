
var Immutable = require('immutable');
var Type = require('../type-inference/type');

var should = require('should');
var functions = require('./functions');
var state = require('./state');
var matchAst = require('../parser/match-ast');
var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var input, result;

var fakeExpressionTranslator = function (context, expression, type, constraints) {
    if (ast.isAtom(expression)) {
        return state.setExpression(context, Immutable.List.of(ast.value(expression)));
    } else {
        // When we get something other than an atom, we assume it's a function application
        // This allows nested function application to be tested
        return state.setExpression(context, state.expression(_translate(context, expression, type, constraints)));
    }
};

var _translate = function (context, expression, type, constraints) {
    return matchAst(context, expression,
        functions.application(fakeExpressionTranslator, type, constraints, function (context, lambda, type, constraints) {
            return _translate(context, ast.child(lambda, 2), type.returnType, constraints);
        })
    );
};

var translate = function (expression, type, constraints) {
    var context = _translate(state.new(), expression, type, constraints);
    return state.expression(context);
};

var errorsFromTranslation = function (expression, type, constraints) {
    var context = _translate(state.new(), expression, type, constraints);
    return state.artifacts(context).filter(function (artifact) { return artifact.type === 'error'; });
};

describe('Function application', function () {
    it('should translate (f) into f()', function () {
        input = list(atom('f'));

        result = translate(input, Type.constant('integer'), Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List(), Type.constant('integer'))]
        ));

        result.should.equal('f()');
    });

    it('should translate (f a) into f(a)', function () {
        input = list(atom('f'), atom('a'));

        result = translate(input, Type.constant('integer'), Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List.of(Type.constant('integer')), Type.constant('integer'))],
            [Type.variable('a'), Type.constant('integer')]
        ));

        result.should.equal('f(a)');
    });

    it('should translate (f a b) into f(a, b)', function () {
        input = list(atom('f'), atom('a'), atom('b'));

        result = translate(input, Type.constant('integer'), Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List.of(
                    Type.constant('integer'),
                    Type.constant('integer')
                ), Type.constant('integer'))],
            [Type.variable('a'), Type.constant('integer')],
            [Type.variable('b'), Type.constant('integer')]
        ));

        result.should.equal('f(a, b)');
    });

    it('should translate (f a b c) into f(a, b, c)', function () {
        input = list(atom('f'), atom('a'), atom('b'), atom('c'));

        result = translate(input, Type.constant('integer'), Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List.of(
                    Type.constant('integer'),
                    Type.constant('integer'),
                    Type.constant('integer')
                ), Type.constant('integer'))],
            [Type.variable('a'), Type.constant('integer')],
            [Type.variable('b'), Type.constant('integer')],
            [Type.variable('c'), Type.constant('integer')]
        ));

        result.should.equal('f(a, b, c)');
    });

    it('should translate ((f)) into f()()', function () {
        input = list(list(atom('f')));

        result = translate(input, Type.constant('integer'), Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List(), Type.lambda(Immutable.List(), Type.constant('integer')))]
        ));

        result.should.equal('f()()');
    });

    it('should translate (f (f 1)) into f(f(1))', function () {
        input = list(atom('f'), list(atom('f'), atom('1')));

        result = translate(input, Type.constant('integer'), Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List.of(Type.constant('integer')), Type.constant('integer'))]
        ));

        result.should.equal('f(f(1))');
    });

    it('should return an error given (f x) and [f (lambda (integer) integer) x (lambda (integer) integer)]', function () {
        input = list(atom('f'), atom('x'));

        var errors = errorsFromTranslation(input, Type.constant('integer'), Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List.of(Type.constant('integer')), Type.constant('integer'))],
            [Type.variable('x'), Type.lambda(Immutable.List.of(Type.constant('integer')), Type.constant('integer'))]
        ));

        errors.size.should.equal(1);
        errors.get(0).message.should.equal('Type mismatch');
        errors.get(0).expectedType.isConstant.should.be.true();
        errors.get(0).expectedType.name.should.equal('integer');
        errors.get(0).foundType.isLambda.should.be.true();
        Type.toString(errors.get(0).foundType).should.equal('(lambda (integer) integer)');
        ast.toString(errors.get(0).expression).should.equal('x');
        ast.toString(errors.get(0).context).should.equal('(f x)');
    });

    it('should return an error given (f (lambda () 1)) and [f (lambda (integer) integer)]', function () {
        input = list(atom('f'), list(atom('lambda'), list(), atom('1')));

        var errors = errorsFromTranslation(input, Type.constant('integer'), Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List.of(Type.constant('integer')), Type.constant('integer'))]
        ));

        errors.size.should.equal(1);
        errors.get(0).message.should.equal('Type mismatch');
        errors.get(0).expectedType.isConstant.should.be.true();
        errors.get(0).expectedType.name.should.equal('integer');
        errors.get(0).foundType.isLambda.should.be.true();
        Type.toString(errors.get(0).foundType).should.equal('(lambda () integer)');
        ast.toString(errors.get(0).expression).should.equal('(lambda () 1)');
        ast.toString(errors.get(0).context).should.equal('(f (lambda () 1))');
    });

    it('should return an error given (lambda () (f (lambda () 1))) [f (lambda (integer) integer)]', function () {
        input = list(atom('lambda'), list(), list(atom('f'), list(atom('lambda'), list(), atom('1'))));

        var errors = errorsFromTranslation(input, Type.lambda(Immutable.List(), Type.constant('integer')), Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List.of(Type.constant('integer')), Type.constant('integer'))]
        ));

        errors.size.should.equal(1);
        errors.get(0).message.should.equal('Type mismatch');
        errors.get(0).expectedType.isConstant.should.be.true();
        errors.get(0).expectedType.name.should.equal('integer');
        errors.get(0).foundType.isLambda.should.be.true();
        Type.toString(errors.get(0).foundType).should.equal('(lambda () integer)');
        ast.toString(errors.get(0).expression).should.equal('(lambda () 1)');
        ast.toString(errors.get(0).context).should.equal('(f (lambda () 1))');
    });
});
