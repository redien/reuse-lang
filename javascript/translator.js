
var state = require('../translation/state');
var functions = require('../translation/functions');
var operators = require('../translation/operators');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var match = require('../translation/match-ast');
var variable = match.variable;

var dropDecimals = function (translate) {
    return (variables) => {
        var translatedExpression = translate(variables);
        return state.new('Math.floor(' + state.expression(translatedExpression) + ')', '');
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
            list(atom('/'), variable('a', 'list'), variable('b', 'list')),    dropDecimals(operators.infixOperator('/', translateExpression, true, true)),
            list(atom('/'), variable('a'), variable('b', 'list')),            dropDecimals(operators.infixOperator('/', translateExpression, false, true)),
            list(atom('/'), variable('a', 'list'), variable('b')),            dropDecimals(operators.infixOperator('/', translateExpression, true, false)),
            list(atom('/'), variable('a'), variable('b')),                    dropDecimals(operators.infixOperator('/', translateExpression)),
        ]
        .concat(operators.infixOperatorsForLanguageWithInt32(translateExpression))
        .concat(functions.application(translateExpression))
        .concat([
            variable('atom', 'atom'), (variables) => state.new(ast.atomValue(variables.get('atom')), '')
        ])
    );
};

module.exports.translate = function (parsedExpression) {
    return state.expression(translateExpression(parsedExpression));
};
