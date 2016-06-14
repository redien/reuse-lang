
var operators = require('../translation/operator-matchers');
var match = require('../translation/match-ast');

module.exports.translate = function translate (parsedExpression) {
    return match(parsedExpression,
        operators.infixOperatorMatchersForLanguageWithInt32(translate)
    );
};
