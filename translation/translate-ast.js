
var unifyAst = require('../parser/unify-ast');

module.exports = function (translationState, parsedExpression, patterns) {
    for (var index = 0; index < patterns.length; index += 2) {
        var pattern = patterns[index];
        var translater = patterns[index + 1];

        var result = unifyAst(pattern, parsedExpression);
        if (result !== unifyAst.NOT_UNIFIED) {
            return translater(translationState, result);
        }
    }

    return parsedExpression;
};

module.exports.variable = unifyAst.variable;
