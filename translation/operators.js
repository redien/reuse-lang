
var operators = module.exports;

var state = require('./state');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var match = require('./match-ast');
var variable = match.variable;

operators.infixOperator = function (operator, translateExpression) {
    return (translationState, variables) => {
        var nestFirst = ast.isList(variables.get('a'));
        var nestSecond = ast.isList(variables.get('b'));

        var first = translateExpression(translationState, variables.get('a'));
        var second = translateExpression(first, variables.get('b'));
        translationState = second;

        var expression = nestFirst ? '(' + state.expression(first) + ')' : state.expression(first);
        expression += ' ' + operator + ' ';
        expression += nestSecond ? '(' + state.expression(second) + ')' : state.expression(second);

        return state.setExpression(translationState, expression);
    };
};

operators.infixOperators = function (translateExpression) {
    var infixOperator = (operator) => operators.infixOperator(operator, translateExpression);

    return [
        list(atom('+'), variable('a'), variable('b')), /* -> */ infixOperator('+'),
        list(atom('*'), variable('a'), variable('b')), /* -> */ infixOperator('*'),
        list(atom('-'), variable('a'), variable('b')), /* -> */ infixOperator('-'),
        list(atom('/'), variable('a'), variable('b')), /* -> */ infixOperator('/'),
    ];
};
