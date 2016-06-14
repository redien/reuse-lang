
var Immutable = require('immutable');
var unifyAst = require('../translation/unify-ast');
var variable = unifyAst.variable;

var list = function () {
    return Immutable.List.of.apply(Immutable.List, arguments);
};

var match = function (parsedExpression, patterns) {
    for (var index = 0; index < patterns.length; index += 2) {
        var pattern = patterns[index];
        var transformer = patterns[index + 1];

        var result = unifyAst(pattern, parsedExpression);
        if (result !== false) {
            return transformer(result);
        }
    }

    return parsedExpression;
};

var transformerForOperator = function (operator) {
    return (variables) => variables.get('a') + ' ' + operator + ' ' + variables.get('b');
};

var matcherForOperator = function (operator) {
    return list(operator, variable('a'), variable('b'));
};

module.exports.translate = function (parsedExpression) {
    return match(parsedExpression, [
        matcherForOperator('+'), transformerForOperator('+'),
        matcherForOperator('*'), transformerForOperator('*'),
        matcherForOperator('-'), transformerForOperator('-'),
        matcherForOperator('/'), transformerForOperator('/'),
    ]);
};
