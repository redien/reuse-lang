
var functionApplication = require('../translation/function-application');
var operators = require('../translation/operators');
var match = require('../translation/match-ast');
var ast = require('../parser/ast');
var variable = match.variable;

module.exports.translate = function translateExpression (parsedExpression) {
    return match(parsedExpression, [
        ].concat(
            operators.infixOperatorsForLanguageWithInt32(translateExpression)
        ).concat(
            functionApplication(translateExpression)
        ).concat([
            variable('atom', 'atom'), (variables) => ast.atomValue(variables.get('atom'))
        ])
    );
};
