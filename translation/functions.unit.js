
var Immutable = require('immutable');
var Type = require('../type-inference/type');

var should = require('should');
var functions = require('./functions');
var state = require('./state');
var translateAst = require('../translation/translate-ast');
var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var input, result;

var fakeExpressionTranslator = function (context, parsedExpression) {
    if (ast.isAtom(parsedExpression)) {
        return state.setExpression(context, Immutable.List.of(ast.value(parsedExpression)));
    } else {
        // When we get something other than an atom, we assume it's a function application
        // This allows nested function application to be tested
        return state.setExpression(context, Immutable.List.of(translate(parsedExpression)));
    }
};

var translate = function (parsedExpression, type, constraints) {
    var context = translateAst(state.new(), parsedExpression,
        functions.application(fakeExpressionTranslator, type, constraints, function (context) { return context; })
    );

    return state.expression(context);
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

    xit('should translate ((f)) into f()()', function () {
        input = list(list(atom('f')));

        result = translate(input, Type.constant('integer'), Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List(), Type.lambda(Immutable.List(), Type.constant('integer')))]
        ));

        result.should.equal('f()()');
    });

    xit('should translate (f (f 1)) into f(f(1))', function () {
        input = list(atom('f'), list(atom('f'), atom('1')));

        result = translate(input, Type.constant('integer'), Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List.of(Type.constant('integer')), Type.constant('integer'))]
        ));

        result.should.equal('f(f(1))');
    });
});
