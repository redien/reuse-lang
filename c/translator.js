
var common = require('../translation/common');
var match = require('../translation/match-ast');
var list = match.list;
var variable = match.variable;

module.exports.translate = function translate (parsedExpression) {
    return match(parsedExpression, [
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
    ]);
};
