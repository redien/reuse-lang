
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
    return (variables) => {
        var expression = operatorTranslator(variables);
        return state.new('Math.floor(' + state.expression(expression) + ')', '');
    };
};

var translateExpression = function (parsedExpression) {
    return match(parsedExpression, [
            list(atom('lambda'), variable('arguments', 'list'), variable('expression')),
                (variables) => {
                    var argumentList = functions.argumentList(variables.get('arguments'));
                    var expression = translateExpression(variables.get('expression'));
                    return state.new('((' + argumentList + ') => ' + state.expression(expression) + ')', state.definitions(expression));
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
    return state.expression(translateExpression(parsedExpression));
};
