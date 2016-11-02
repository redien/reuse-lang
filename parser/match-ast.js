
var ast = require('../parser/ast');
var unifyAst = require('../parser/unify-ast');

module.exports = function (context, expression, cases) {
    for (var index = 0; index < cases.length; index += 2) {
        var pattern = cases[index];
        var transformer = cases[index + 1];

        var result = unifyAst(pattern, expression);
        if (result !== unifyAst.NOT_UNIFIED) {
            return transformer(context, result, expression);
        }
    }

    throw new Error('No pattern matches `' + ast.toString(expression) + '`');
};

module.exports.variable = unifyAst.variable;
