
var common = require('../translation/common');
var match = require('../translation/match-ast');

module.exports.translate = function translate (parsedExpression) {
    return match(parsedExpression,
        common.infixOperatorMatchersForLanguageWithInt32(translate)
    );
};
