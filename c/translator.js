
var functionApplication = require('../translation/function-application');
var operators = require('../translation/operator-matchers');
var match = require('../translation/match-ast');
var list = match.list;
var variable = match.variable;

module.exports.translate = function translate (parsedExpression) {
    return match(parsedExpression,
        operators.infixOperatorMatchersForLanguageWithInt32(translate).concat(
            functionApplication(translate)
        )
    );
};
