
var operators = module.exports;

var Immutable = require('immutable');
var Type = require('../type-inference/type');

var state = require('./state');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var matchAst = require('../parser/match-ast');
var variable = matchAst.variable;

operators.infixOperator = function (operator, translateExpression) {
    return function (context, variables, expression) {
        var nestFirst = ast.isList(variables.get('a'));
        var nestSecond = ast.isList(variables.get('b'));

        var first = translateExpression(context, variables.get('a'));
        var second = translateExpression(first, variables.get('b'));
        context = second;

        var parts = Immutable.List();
        if (nestFirst) {
            parts = parts.push('(').push(state.expression(first)).push(')');
        } else {
            parts = parts.push(state.expression(first));
        }
        parts = parts.push(' ').push(operator).push(' ');
        if (nestSecond) {
            parts = parts.push('(').push(state.expression(second)).push(')');
        } else {
            parts = parts.push(state.expression(second));
        }

        return state.setExpression(context, parts);
    };
};

operators.infixOperators = function (translateExpression) {
    var infixOperator = function (operator) { return operators.infixOperator(operator, translateExpression); };

    return [
        list(atom('+'), variable('a'), variable('b')), /* -> */ infixOperator('+'),
        list(atom('*'), variable('a'), variable('b')), /* -> */ infixOperator('*'),
        list(atom('-'), variable('a'), variable('b')), /* -> */ infixOperator('-'),
        list(atom('/'), variable('a'), variable('b')), /* -> */ infixOperator('/'),
    ];
};

operators.constraints = Immutable.List.of(
    [Type.variable('+'), Type.lambda(Immutable.List.of(Type.constant('integer'), Type.constant('integer')), Type.constant('integer'))],
    [Type.variable('-'), Type.lambda(Immutable.List.of(Type.constant('integer'), Type.constant('integer')), Type.constant('integer'))],
    [Type.variable('*'), Type.lambda(Immutable.List.of(Type.constant('integer'), Type.constant('integer')), Type.constant('integer'))],
    [Type.variable('/'), Type.lambda(Immutable.List.of(Type.constant('integer'), Type.constant('integer')), Type.constant('integer'))]
);
