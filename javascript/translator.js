
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

module.exports.translate = function (parsedExpression) {
    return match(parsedExpression, [
        list('+', variable('a'), variable('b')), (variables) => variables.get('a') + ' + ' + variables.get('b'),
        list('*', variable('a'), variable('b')), (variables) => variables.get('a') + ' * ' + variables.get('b'),
        list('-', variable('a'), variable('b')), (variables) => variables.get('a') + ' - ' + variables.get('b'),
        list('/', variable('a'), variable('b')), (variables) => variables.get('a') + ' / ' + variables.get('b'),
    ]);
};
