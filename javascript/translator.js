
var Immutable = require('immutable');
var unifyAst = require('../translation/unify-ast');
var variable = unifyAst.variable;

var list = function () {
    return Immutable.List.of.apply(Immutable.List, arguments);
};

var match = function (parsedExpression, patterns) {
    for (var index = 0; index < patterns.length; index += 2) {
        var pattern = patterns[index];
        var transformer = patterns[index + 1];

        var result = unifyAst(pattern, parsedExpression);
        if (result !== false) {
            return transformer(result);
        }
    }

    return parsedExpression;
};

var dropDecimals = function (translator) {
    return (variables) => {
        return 'Math.floor(' + translator(variables) + ')';
    };
};

var translatorForOperator = function (operator, translate, nestFirst, nestSecond) {
    return (variables) => {
        var first = translate(variables.get('a'));
        var second = translate(variables.get('b'));

        first = nestFirst ? '(' + first + ')' : first;
        second = nestSecond ? '(' + second + ')' : second;

        return first + ' ' + operator + ' ' + second;
    };
};

module.exports.translate = function translate (parsedExpression) {
    return match(parsedExpression, [
        list('+', variable('a', 'list'), variable('b', 'list')), translatorForOperator('+', translate, true, true),
        list('*', variable('a', 'list'), variable('b', 'list')), translatorForOperator('*', translate, true, true),
        list('-', variable('a', 'list'), variable('b', 'list')), translatorForOperator('-', translate, true, true),
        list('/', variable('a', 'list'), variable('b', 'list')), dropDecimals(translatorForOperator('/', translate, true, true)),
        list('+', variable('a'), variable('b', 'list')), translatorForOperator('+', translate, false, true),
        list('*', variable('a'), variable('b', 'list')), translatorForOperator('*', translate, false, true),
        list('-', variable('a'), variable('b', 'list')), translatorForOperator('-', translate, false, true),
        list('/', variable('a'), variable('b', 'list')), dropDecimals(translatorForOperator('/', translate, false, true)),
        list('+', variable('a', 'list'), variable('b')), translatorForOperator('+', translate, true, false),
        list('*', variable('a', 'list'), variable('b')), translatorForOperator('*', translate, true, false),
        list('-', variable('a', 'list'), variable('b')), translatorForOperator('-', translate, true, false),
        list('/', variable('a', 'list'), variable('b')), dropDecimals(translatorForOperator('/', translate, true, false)),
        list('+', variable('a'), variable('b')), translatorForOperator('+', translate),
        list('*', variable('a'), variable('b')), translatorForOperator('*', translate),
        list('-', variable('a'), variable('b')), translatorForOperator('-', translate),
        list('/', variable('a'), variable('b')), dropDecimals(translatorForOperator('/', translate)),
    ]);
};
