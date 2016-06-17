
var unifyAst = require('./unify-ast');

module.exports = function (translationState, parsedExpression, patterns) {
    for (var index = 0; index < patterns.length; index += 2) {
        var pattern = patterns[index];
        var transformer = patterns[index + 1];

        var result = unifyAst(pattern, parsedExpression);
        if (result !== unifyAst.NOT_UNIFIED) {
            return transformer(translationState, result);
        }
    }

    return parsedExpression;
};

module.exports.variable = unifyAst.variable;
