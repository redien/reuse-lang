
var state = require('../translation/state');
var functions = require('../translation/functions');
var operators = require('../translation/operators');
var symbols = require('../translation/symbols');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var match = require('../translation/match-ast');
var variable = match.variable;

var translateExpression = function (translationState, parsedExpression) {
    return match(translationState, parsedExpression, [
            list(atom('lambda'), variable('arguments', 'list'), variable('expression')),
                (translationState, variables) => {
                    var argumentList = functions.argumentList(variables.get('arguments'));
                    translationState = translateExpression(translationState, variables.get('expression'));

                    var id = state.lambdaId(translationState);
                    translationState = state.incrementLambdaId(translationState);

                    var functionDefinition = 'int reuse_gen_lambda' + id + '(' + argumentList + ') { return ' + state.expression(translationState) + '; }\n';

                    translationState = state.setExpression(translationState, 'reuse_gen_lambda' + id);
                    return state.addDefinition(translationState, functionDefinition);
                },
        ]
        .concat(operators.infixOperators(translateExpression))
        .concat(functions.application(translateExpression))
        .concat(symbols.atom(translateExpression))
    );
};

module.exports.translate = function (parsedExpression) {
    var translationState = translateExpression(state.new(), parsedExpression);
    return state.definitions(translationState) + 'int expression() { return ' + state.expression(translationState) + '; }';
};
