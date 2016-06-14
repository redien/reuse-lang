
var common = require('../translation/common');
var match = require('../translation/match-ast');
var list = match.list;
var variable = match.variable;

var dropDecimals = function (translator) {
    return (variables) => {
        return 'Math.floor(' + translator(variables) + ')';
    };
};

module.exports.translate = function translate (parsedExpression) {
    return match(parsedExpression, [
        // Overrides division operator to round off decimal points
        list('/', variable('a', 'list'), variable('b', 'list')),    dropDecimals(common.infixOperator('/', translate, true, true)),
        list('/', variable('a'), variable('b', 'list')),            dropDecimals(common.infixOperator('/', translate, false, true)),
        list('/', variable('a', 'list'), variable('b')),            dropDecimals(common.infixOperator('/', translate, true, false)),
        list('/', variable('a'), variable('b')),                    dropDecimals(common.infixOperator('/', translate)),
    ].concat(
        common.infixOperatorMatchersForLanguageWithInt32(translate)
    ));
};
