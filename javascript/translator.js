
var state = require('../translation/state');
var functions = require('../translation/functions');
var operators = require('../translation/operators');
var symbols = require('../translation/symbols');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var match = require('../translation/match-ast');
var variable = match.variable;

var dropDecimals = function (operatorTranslator) {
    return (translationState, variables) => {
        var expression = operatorTranslator(translationState, variables);
        return state.setExpression(expression, 'Math.floor(' + state.expression(expression) + ')');
    };
};

var translateExpression = function (translationState, parsedExpression) {
    return match(translationState, parsedExpression, [
            list(atom('lambda'), variable('arguments', 'list'), variable('expression')),
                (translationState, variables) => {
                    var argumentList = functions.argumentList(variables.get('arguments'));
                    var expression = translateExpression(translationState, variables.get('expression'));
                    return state.setExpression(expression, '((' + argumentList + ') => ' + state.expression(expression) + ')');
                },

            // Overrides division operator to round off decimal points
            list(atom('/'), variable('a'), variable('b')),
                dropDecimals(operators.infixOperator('/', translateExpression)),
        ]
        .concat(operators.infixOperators(translateExpression))
        .concat(functions.application(translateExpression))
        .concat(symbols.atom(translateExpression))
    );
};

module.exports.translate = function (parsedExpression) {
    return state.expression(translateExpression(state.new(), parsedExpression));
};
