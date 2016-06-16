
var unifyAst = require('./unify-ast');

module.exports = function (parsedExpression, patterns) {
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

module.exports.variable = unifyAst.variable;
