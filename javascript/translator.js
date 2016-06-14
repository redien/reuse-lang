
var functionApplication = require('../translation/function-application');
var operators = require('../translation/operator-matchers');
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
        list('/', variable('a', 'list'), variable('b', 'list')),    dropDecimals(operators.infixOperator('/', translate, true, true)),
        list('/', variable('a'), variable('b', 'list')),            dropDecimals(operators.infixOperator('/', translate, false, true)),
        list('/', variable('a', 'list'), variable('b')),            dropDecimals(operators.infixOperator('/', translate, true, false)),
        list('/', variable('a'), variable('b')),                    dropDecimals(operators.infixOperator('/', translate)),
    ].concat(
        operators.infixOperatorMatchersForLanguageWithInt32(translate)
    ).concat(
        functionApplication(translate)
    ));
};
