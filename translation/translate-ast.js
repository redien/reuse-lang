
var ast = require('../parser/ast');
var unifyAst = require('../parser/unify-ast');
var Immutable = require('immutable');
var Type = require('../type-inference/type');

module.exports = function (context, parsedExpression, patterns) {
    var constraints = Immutable.List();
    for (var index = 0; index < patterns.length; index += 2) {
        var pattern = patterns[index];
        var translater = patterns[index + 1];

        var result = unifyAst(pattern, parsedExpression);
        if (result !== unifyAst.NOT_UNIFIED) {
            return translater(context, result, parsedExpression);
        }
    }

    throw new Error('No pattern can translate `' + ast.toString(parsedExpression) + '`');
};

module.exports.variable = unifyAst.variable;
