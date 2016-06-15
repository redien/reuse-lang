
var operators = module.exports;

var ast = require('../parser/ast');
var match = require('../translation/match-ast');
var atom = match.atom;
var list = match.list;
var variable = match.variable;

operators.infixOperator = function (operator, translateExpression, nestFirst, nestSecond) {
    return (variables) => {
        var first = translateExpression(variables.get('a'));
        var second = translateExpression(variables.get('b'));

        first = nestFirst ? '(' + first + ')' : first;
        second = nestSecond ? '(' + second + ')' : second;

        return first + ' ' + operator + ' ' + second;
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
