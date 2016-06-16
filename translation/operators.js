
var operators = module.exports;

var state = require('./state');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var match = require('./match-ast');
var variable = match.variable;

operators.infixOperator = function (operator, translateExpression, nestFirst, nestSecond) {
    return (variables) => {
        var first = translateExpression(variables.get('a'));
        var second = translateExpression(variables.get('b'));

        var expression = nestFirst ? '(' + state.expression(first) + ')' : state.expression(first);
        expression += ' ' + operator + ' ';
        expression += nestSecond ? '(' + state.expression(second) + ')' : state.expression(second);

        return state.new(expression, state.definitions(first) + state.definitions(second));
    };
};

operators.infixOperatorsForLanguageWithInt32 = function (translateExpression) {
    return [
        list(atom('+'), variable('a', 'list'), variable('b', 'list')),    operators.infixOperator('+', translateExpression, true, true),
        list(atom('*'), variable('a', 'list'), variable('b', 'list')),    operators.infixOperator('*', translateExpression, true, true),
        list(atom('-'), variable('a', 'list'), variable('b', 'list')),    operators.infixOperator('-', translateExpression, true, true),
        list(atom('/'), variable('a', 'list'), variable('b', 'list')),    operators.infixOperator('/', translateExpression, true, true),
        list(atom('+'), variable('a'), variable('b', 'list')),            operators.infixOperator('+', translateExpression, false, true),
        list(atom('*'), variable('a'), variable('b', 'list')),            operators.infixOperator('*', translateExpression, false, true),
        list(atom('-'), variable('a'), variable('b', 'list')),            operators.infixOperator('-', translateExpression, false, true),
        list(atom('/'), variable('a'), variable('b', 'list')),            operators.infixOperator('/', translateExpression, false, true),
        list(atom('+'), variable('a', 'list'), variable('b')),            operators.infixOperator('+', translateExpression, true, false),
        list(atom('*'), variable('a', 'list'), variable('b')),            operators.infixOperator('*', translateExpression, true, false),
        list(atom('-'), variable('a', 'list'), variable('b')),            operators.infixOperator('-', translateExpression, true, false),
        list(atom('/'), variable('a', 'list'), variable('b')),            operators.infixOperator('/', translateExpression, true, false),
        list(atom('+'), variable('a'), variable('b')),                    operators.infixOperator('+', translateExpression),
        list(atom('*'), variable('a'), variable('b')),                    operators.infixOperator('*', translateExpression),
        list(atom('-'), variable('a'), variable('b')),                    operators.infixOperator('-', translateExpression),
        list(atom('/'), variable('a'), variable('b')),                    operators.infixOperator('/', translateExpression),
    ];
};
