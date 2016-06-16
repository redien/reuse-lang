
var functionApplication = require('../translation/function-application');
var operators = require('../translation/operators');
var match = require('../translation/match-ast');
var ast = require('../parser/ast');
var atom = match.atom;
var list = match.list;
var variable = match.variable;

var dropDecimals = function (translator) {
    return (variables) => {
        return 'Math.floor(' + translator(variables) + ')';
    };
};

module.exports.translate = function translateExpression (parsedExpression) {
    return match(parsedExpression, [
            list(atom('lambda'), variable('arguments', 'list'), variable('expression')),
            (variables) => '(() => ' + ast.atomValue(variables.get('expression')) + ')',

            // Overrides division operator to round off decimal points
            list(atom('/'), variable('a', 'list'), variable('b', 'list')),    dropDecimals(operators.infixOperator('/', translateExpression, true, true)),
            list(atom('/'), variable('a'), variable('b', 'list')),            dropDecimals(operators.infixOperator('/', translateExpression, false, true)),
            list(atom('/'), variable('a', 'list'), variable('b')),            dropDecimals(operators.infixOperator('/', translateExpression, true, false)),
            list(atom('/'), variable('a'), variable('b')),                    dropDecimals(operators.infixOperator('/', translateExpression)),
        ].concat(
            operators.infixOperatorsForLanguageWithInt32(translateExpression)
        ).concat(
            functionApplication(translateExpression)
        ).concat([
            variable('atom', 'atom'), (variables) => ast.atomValue(variables.get('atom'))
        ])
    );
};
