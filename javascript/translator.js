
var functionApplication = require('../translation/function-application');
var operators = require('../translation/operators');
var match = require('../translation/match-ast');
var list = match.list;
var variable = match.variable;

var dropDecimals = function (translator) {
    return (variables) => {
        return 'Math.floor(' + translator(variables) + ')';
    };
};

module.exports.translate = function translateExpression (parsedExpression) {
    return match(parsedExpression, [
        // Overrides division operator to round off decimal points
        list('/', variable('a', 'list'), variable('b', 'list')),    dropDecimals(operators.infixOperator('/', translateExpression, true, true)),
        list('/', variable('a'), variable('b', 'list')),            dropDecimals(operators.infixOperator('/', translateExpression, false, true)),
        list('/', variable('a', 'list'), variable('b')),            dropDecimals(operators.infixOperator('/', translateExpression, true, false)),
        list('/', variable('a'), variable('b')),                    dropDecimals(operators.infixOperator('/', translateExpression)),
    ].concat(
        operators.infixOperatorMatchersForLanguageWithInt32(translateExpression)
    ).concat(
        functionApplication(translateExpression)
    ));
};
