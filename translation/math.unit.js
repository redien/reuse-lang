
var Immutable = require('immutable');
var Type = require('../type-inference/type');

var should = require('should');
var math = require('./math');
var state = require('./state');
var matchAst = require('../parser/match-ast');
var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var input, result;

var fakeExpressionTranslator = function (context, expression) {
    if (ast.isAtom(expression)) {
        return state.setExpression(context, Immutable.List.of(ast.value(expression)));
    } else {
        // When we get something other than an atom, we assume it's a function application
        // This allows nested function application to be tested
        return state.setExpression(context, Immutable.List.of(_translate(context, expression)));
    }
};

var _translate = function (context, expression) {
    context = matchAst(context, expression,
        math.functions(fakeExpressionTranslator)
    );

    return state.expression(context);
};

var translate = function (expression) {
    return _translate(state.new(), expression);
};

describe('Math functions', function () {
    it('should translate (max a b) into max(a, b)', function () {
        input = list(atom('max'), atom('a'), atom('b'));

        result = translate(input);

        result.should.equal('max(a, b)');
    });

    it('should translate (min a b) into min(a, b)', function () {
        input = list(atom('min'), atom('a'), atom('b'));

        result = translate(input);

        result.should.equal('min(a, b)');
    });
});
