
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

var fakeExpressionTranslator = function (context, parsedExpression) {
    if (ast.isAtom(parsedExpression)) {
        return state.setExpression(context, Immutable.List.of(ast.value(parsedExpression)));
    } else {
        // When we get something other than an atom, we assume it's a function application
        // This allows nested function application to be tested
        return state.setExpression(context, Immutable.List.of(translate(parsedExpression)));
    }
};

var translate = function (parsedExpression) {
    var context = matchAst(state.new(), parsedExpression,
        math.functions(fakeExpressionTranslator)
    );

    return state.expression(context);
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
