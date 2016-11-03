
var Immutable = require('immutable');

var should = require('should');
var operators = require('./operators');
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
        // When we get something other than an atom, we assume it's an infix operator
        // This allows nested operators to be tested
        return state.setExpression(context, Immutable.List.of(_translate(context, expression)));
    }
};

var _translate = function (context, expression) {
    var context = matchAst(context, expression,
        operators.infixOperators(fakeExpressionTranslator)
    );

    return state.expression(context);
};

var translate = function (expression) {
    return _translate(state.new(), expression);
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
