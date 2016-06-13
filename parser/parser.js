
var Immutable = require('immutable');

var skipWhiteSpace = function (input, index) {
    while (input[index] === ' ') {
        index += 1;
    }
    return index;
};

var parseExpression = function (input, index) {
    index = skipWhiteSpace(input, index);

    if (input[index] === '(') {
        return parseList(input, index + 1);
    } else {
        return parseAtom(input, index);
    }
};

var parseList = function (input, index) {
    var list = Immutable.List();

    while (index < input.length && input[index] !== ')') {
        var expression = parseExpression(input, index);
        list = list.push(expression.ast);
        index = expression.nextIndex + 1;
        index = skipWhiteSpace(input, index);
    }

    return {ast: list, nextIndex: index + 1};
};

var parseAtom = function (input, index) {
    var start = index;
    while (index < input.length
        && input[index] !== ' '
        && input[index] !== ')') {
        index += 1;
    }
    return {ast: input.substring(start, index), nextIndex: index};
};

module.exports.parse = function (input) {
    return parseExpression(input, 0).ast;
};
