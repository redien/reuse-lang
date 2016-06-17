
var state = require('../translation/state');
var functions = require('../translation/functions');
var operators = require('../translation/operators');
var symbols = require('../translation/symbols');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var match = require('../parser/match-ast');
var variable = match.variable;

var translateExpression = function (translationState, parsedExpression) {
    return match(translationState, parsedExpression, [
            list(atom('lambda'), variable('arguments', 'list'), variable('expression')),
                (translationState, variables) => {
                    var argumentList = functions.argumentList(variables.get('arguments'));
                    translationState = translateExpression(translationState, variables.get('expression'));
                    return state.setExpression(translationState, '(|' + argumentList + '| ' + state.expression(translationState) + ')');
                },
        ]
        .concat(operators.infixOperators(translateExpression))
        .concat(functions.application(translateExpression))
        .concat(symbols.atom(translateExpression))
    );
};

module.exports.translate = function (parsedExpression) {
    return state.expression(translateExpression(state.new(), parsedExpression));
};
