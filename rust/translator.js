
var functionApplication = require('../translation/function-application');
var operators = require('../translation/operator-matchers');
var match = require('../translation/match-ast');

module.exports.translate = function translate (parsedExpression) {
    return match(parsedExpression,
        operators.infixOperatorMatchersForLanguageWithInt32(translate).concat(
            functionApplication(translate)
        )
    );
};
