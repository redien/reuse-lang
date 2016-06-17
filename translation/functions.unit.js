
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
        return state.setExpression(context, ast.atomValue(parsedExpression));
    } else {
        // When we get something other than an atom, we assume it's a function application
        // This allows nested function application to be tested
        return state.setExpression(context, translate(parsedExpression));
    }
};

var translate = function (parsedExpression) {
    var context = translateAst(state.new(), parsedExpression,
        functions.application(fakeExpressionTranslator)
    );

    return state.expression(context);
};

describe('Function application', function () {
    it('should translate (f) into f()', function () {
        input = list(atom('f'));

        result = translate(input);

        result.should.equal('f()');
    });

    it('should translate (f a) into f(a)', function () {
        input = list(atom('f'), atom('a'));

        result = translate(input);

        result.should.equal('f(a)');
    });

    it('should translate (f a b) into f(a, b)', function () {
        input = list(atom('f'), atom('a'), atom('b'));

        result = translate(input);

        result.should.equal('f(a, b)');
    });

    it('should translate (f a b c) into f(a, b, c)', function () {
        input = list(atom('f'), atom('a'), atom('b'), atom('c'));

        result = translate(input);

        result.should.equal('f(a, b, c)');
    });

    it('should translate ((f)) into f()()', function () {
        input = list(list(atom('f')));

        result = translate(input);

        result.should.equal('f()()');
    });

    it('should translate (f (f)) into f(f())', function () {
        input = list(atom('f'), list(atom('f')));

        result = translate(input);

        result.should.equal('f(f())');
    });
});
