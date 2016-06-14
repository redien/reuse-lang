
var operators = module.exports;

var match = require('../translation/match-ast');
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
        list('+', variable('a', 'list'), variable('b', 'list')),    operators.infixOperator('+', translateExpression, true, true),
        list('*', variable('a', 'list'), variable('b', 'list')),    operators.infixOperator('*', translateExpression, true, true),
        list('-', variable('a', 'list'), variable('b', 'list')),    operators.infixOperator('-', translateExpression, true, true),
        list('/', variable('a', 'list'), variable('b', 'list')),    operators.infixOperator('/', translateExpression, true, true),
        list('+', variable('a'), variable('b', 'list')),            operators.infixOperator('+', translateExpression, false, true),
        list('*', variable('a'), variable('b', 'list')),            operators.infixOperator('*', translateExpression, false, true),
        list('-', variable('a'), variable('b', 'list')),            operators.infixOperator('-', translateExpression, false, true),
        list('/', variable('a'), variable('b', 'list')),            operators.infixOperator('/', translateExpression, false, true),
        list('+', variable('a', 'list'), variable('b')),            operators.infixOperator('+', translateExpression, true, false),
        list('*', variable('a', 'list'), variable('b')),            operators.infixOperator('*', translateExpression, true, false),
        list('-', variable('a', 'list'), variable('b')),            operators.infixOperator('-', translateExpression, true, false),
        list('/', variable('a', 'list'), variable('b')),            operators.infixOperator('/', translateExpression, true, false),
        list('+', variable('a'), variable('b')),                    operators.infixOperator('+', translateExpression),
        list('*', variable('a'), variable('b')),                    operators.infixOperator('*', translateExpression),
        list('-', variable('a'), variable('b')),                    operators.infixOperator('-', translateExpression),
        list('/', variable('a'), variable('b')),                    operators.infixOperator('/', translateExpression),
    ];
};
