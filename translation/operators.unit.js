
var should = require('should');
var operators = require('./operators');
var match = require('./match-ast');
var state = require('./state');
var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var input, result;

var stubExpressionTranslator = function (translationState, parsedExpression) {
    if (ast.isAtom(parsedExpression)) {
        return state.setExpression(translationState, ast.atomValue(parsedExpression));
    } else {
        // When we get something other than an atom, we assume it's an infix operator
        return state.setExpression(translationState, translate(parsedExpression));
    }
};

var translate = function (parsedExpression) {
    var translationState = match(state.new(), parsedExpression,
        operators.infixOperators(stubExpressionTranslator)
    );

    return state.expression(translationState);
};

describe('Integer arithmetic', function () {
    it('should translate (+ a b) into a + b', function () {
        input = list(atom('+'), atom('a'), atom('b'));

        result = translate(input);

        result.should.equal('a + b');
    });

    it('should translate (+ 1 2) into 1 + 2', function () {
        input = list(atom('+'), atom('1'), atom('2'));

        result = translate(input);

        result.should.equal('1 + 2');
    });

    it('should translate (* 1 2) into 1 * 2', function () {
        input = list(atom('*'), atom('1'), atom('2'));

        result = translate(input);

        result.should.equal('1 * 2');
    });

    it('should translate (* 1 (+ 2 3)) into 1 * (2 + 3)', function () {
        input = list(atom('*'), atom('1'), list(atom('+'), atom('2'), atom('3')));

        result = translate(input);

        result.should.equal('1 * (2 + 3)');
    });

    it('should translate (* (+ 1 2) (- 3 4)) into (1 + 2) * (3 - 4)', function () {
        input = list(atom('*'), list(atom('+'), atom('1'), atom('2')), list(atom('-'), atom('3'), atom('4')));

        result = translate(input);

        result.should.equal('(1 + 2) * (3 - 4)');
    });
});
