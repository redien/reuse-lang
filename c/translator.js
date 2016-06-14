
var functionApplication = require('../translation/function-application');
var operators = require('../translation/operators');
var match = require('../translation/match-ast');
var list = match.list;
var variable = match.variable;

module.exports.translate = function translateExpression (parsedExpression) {
    return match(parsedExpression,
        operators.infixOperatorMatchersForLanguageWithInt32(translateExpression).concat(
            functionApplication(translateExpression)
        )
    );
};
