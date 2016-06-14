
var common = module.exports;

var match = require('../translation/match-ast');
var list = match.list;
var variable = match.variable;

common.infixOperator = function (operator, translate, nestFirst, nestSecond) {
    return (variables) => {
        var first = translate(variables.get('a'));
        var second = translate(variables.get('b'));

        first = nestFirst ? '(' + first + ')' : first;
        second = nestSecond ? '(' + second + ')' : second;

        return first + ' ' + operator + ' ' + second;
    };
};

common.infixOperatorMatchersForLanguageWithInt32 = function (translate) {
    return [
        list('+', variable('a', 'list'), variable('b', 'list')),    common.infixOperator('+', translate, true, true),
        list('*', variable('a', 'list'), variable('b', 'list')),    common.infixOperator('*', translate, true, true),
        list('-', variable('a', 'list'), variable('b', 'list')),    common.infixOperator('-', translate, true, true),
        list('/', variable('a', 'list'), variable('b', 'list')),    common.infixOperator('/', translate, true, true),
        list('+', variable('a'), variable('b', 'list')),            common.infixOperator('+', translate, false, true),
        list('*', variable('a'), variable('b', 'list')),            common.infixOperator('*', translate, false, true),
        list('-', variable('a'), variable('b', 'list')),            common.infixOperator('-', translate, false, true),
        list('/', variable('a'), variable('b', 'list')),            common.infixOperator('/', translate, false, true),
        list('+', variable('a', 'list'), variable('b')),            common.infixOperator('+', translate, true, false),
        list('*', variable('a', 'list'), variable('b')),            common.infixOperator('*', translate, true, false),
        list('-', variable('a', 'list'), variable('b')),            common.infixOperator('-', translate, true, false),
        list('/', variable('a', 'list'), variable('b')),            common.infixOperator('/', translate, true, false),
        list('+', variable('a'), variable('b')),                    common.infixOperator('+', translate),
        list('*', variable('a'), variable('b')),                    common.infixOperator('*', translate),
        list('-', variable('a'), variable('b')),                    common.infixOperator('-', translate),
        list('/', variable('a'), variable('b')),                    common.infixOperator('/', translate),
    ];
};
