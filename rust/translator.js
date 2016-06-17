
var state = require('../translation/state');
var functions = require('../translation/functions');
var operators = require('../translation/operators');
var symbols = require('../translation/symbols');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var translateAst = require('../translation/translate-ast');
var variable = translateAst.variable;

var translateExpression = function (context, parsedExpression) {
    return translateAst(context, parsedExpression, [
            list(atom('lambda'), variable('arguments', 'list'), variable('expression')),
                (context, variables) => {
                    var argumentList = functions.argumentList(variables.get('arguments'));
                    context = translateExpression(context, variables.get('expression'));
                    return state.setExpression(context, '(|' + argumentList + '| ' + state.expression(context) + ')');
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
