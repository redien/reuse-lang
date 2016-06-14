
var operators = module.exports;

var match = require('../translation/match-ast');
var list = match.list;
var variable = match.variable;

operators.infixOperator = function (operator, translate, nestFirst, nestSecond) {
    return (variables) => {
        var first = translate(variables.get('a'));
        var second = translate(variables.get('b'));

        first = nestFirst ? '(' + first + ')' : first;
        second = nestSecond ? '(' + second + ')' : second;

        return first + ' ' + operator + ' ' + second;
    };
};

operators.infixOperatorMatchersForLanguageWithInt32 = function (translate) {
    return [
        list('+', variable('a', 'list'), variable('b', 'list')),    operators.infixOperator('+', translate, true, true),
        list('*', variable('a', 'list'), variable('b', 'list')),    operators.infixOperator('*', translate, true, true),
        list('-', variable('a', 'list'), variable('b', 'list')),    operators.infixOperator('-', translate, true, true),
        list('/', variable('a', 'list'), variable('b', 'list')),    operators.infixOperator('/', translate, true, true),
        list('+', variable('a'), variable('b', 'list')),            operators.infixOperator('+', translate, false, true),
        list('*', variable('a'), variable('b', 'list')),            operators.infixOperator('*', translate, false, true),
        list('-', variable('a'), variable('b', 'list')),            operators.infixOperator('-', translate, false, true),
        list('/', variable('a'), variable('b', 'list')),            operators.infixOperator('/', translate, false, true),
        list('+', variable('a', 'list'), variable('b')),            operators.infixOperator('+', translate, true, false),
        list('*', variable('a', 'list'), variable('b')),            operators.infixOperator('*', translate, true, false),
        list('-', variable('a', 'list'), variable('b')),            operators.infixOperator('-', translate, true, false),
        list('/', variable('a', 'list'), variable('b')),            operators.infixOperator('/', translate, true, false),
        list('+', variable('a'), variable('b')),                    operators.infixOperator('+', translate),
        list('*', variable('a'), variable('b')),                    operators.infixOperator('*', translate),
        list('-', variable('a'), variable('b')),                    operators.infixOperator('-', translate),
        list('/', variable('a'), variable('b')),                    operators.infixOperator('/', translate),
    ];
};
