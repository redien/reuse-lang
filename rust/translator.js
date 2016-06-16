
var state = require('../translation/state');
var functions = require('../translation/functions');
var operators = require('../translation/operators');
var symbols = require('../translation/symbols');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var match = require('../translation/match-ast');
var variable = match.variable;

var translateExpression = function (parsedExpression) {
    return match(parsedExpression, [
            list(atom('lambda'), variable('arguments', 'list'), variable('expression')),
                (variables) => {
                    var argumentList = functions.argumentList(variables.get('arguments'));
                    var expression = translateExpression(variables.get('expression'));
                    return state.new('(|' + argumentList + '| ' + state.expression(expression) + ')', state.definitions(expression));
                },
        ]
        .concat(operators.infixOperatorsForLanguageWithInt32(translateExpression))
        .concat(functions.application(translateExpression))
        .concat(symbols.atom(translateExpression))
    );
};

module.exports.translate = function (parsedExpression) {
    return state.expression(translateExpression(parsedExpression));
};
