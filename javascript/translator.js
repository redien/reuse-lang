
var state = require('../translation/state');
var functions = require('../translation/functions');
var operators = require('../translation/operators');
var symbols = require('../translation/symbols');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var translateAst = require('../translation/translate-ast');
var variable = translateAst.variable;

var dropDecimals = function (operatorTranslator) {
    return (context, variables) => {
        context = operatorTranslator(context, variables);
        return state.setExpression(context, 'Math.floor(' + state.expression(context) + ')');
    };
};

var translateExpression = function (context, parsedExpression) {
    return translateAst(context, parsedExpression, [
            list(atom('lambda'), variable('arguments', 'list'), variable('expression')),
                (context, variables) => {
                    var argumentList = functions.argumentList(variables.get('arguments'));
                    context = translateExpression(context, variables.get('expression'));
                    return state.setExpression(context, '((' + argumentList + ') => ' + state.expression(context) + ')');
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
