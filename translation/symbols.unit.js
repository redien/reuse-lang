
var should = require('should');
var symbols = require('./symbols');
var state = require('./state');
var translateAst = require('../translation/translate-ast');
var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var input, result;

var fakeExpressionTranslator = function (context, parsedExpression) {
    // Do nothing.
    return parsedExpression;
};

var translate = function (parsedExpression) {
    var context = translateAst(state.new(), parsedExpression,
        symbols.atom(fakeExpressionTranslator)
    );

    return state.expression(context);
};

describe('Symbols', function () {
    it('should translate a into a', function () {
        input = atom('a');

        result = translate(input);

        result.should.equal('a');
    });
});
