
var Immutable = require('immutable');
var ast = require('../parser/ast');
var type = require('./type');

var isInteger = function (atom) {
    return !isNaN(ast.atomValue(atom));
};

var isLambdaExpression = function (expression) {
    return ast.isAtom(expression) && ast.atomValue(expression) === 'lambda';
};

var infer = function (parsedExpression, scope) {
    if (ast.isAtom(parsedExpression) && isInteger(ast.atomValue(parsedExpression))) {
        return type.constant();

    } else if (ast.isAtom(parsedExpression)) {
        var typeFromScope = scope.get(ast.atomValue(parsedExpression));
        return type.symbol(typeFromScope);

    } else {
        var func = ast.listChild(parsedExpression, 0);

        if (isLambdaExpression(func)) {
            var expression = ast.listChild(parsedExpression, 2);
            var expressionResult = infer(expression, scope);
            return type.lambda(Immutable.List(), expressionResult.type, expressionResult);

        } else {
            var expressions = Immutable.List();
            for (var i = 0; i < ast.listSize(parsedExpression); i++) {
                var expression = ast.listChild(parsedExpression, i);
                expressions = expressions.push(infer(expression, scope));
            }

            return type.application(type.constant().type, expressions);
        }
    }
};

var builtins = Immutable.Map.of(
    '+', type.lambda(Immutable.List.of(type.constant().type, type.constant().type), type.constant().type).type
);

module.exports = function (parsedExpression, scope) {
    scope = builtins.merge(scope);
    return infer(parsedExpression, scope);
};
