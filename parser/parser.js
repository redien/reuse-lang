
var Immutable = require('immutable');

var space = ' ';
var startParenthesis = '(';
var endParenthesis = ')';

var skipWhiteSpace = function (input, index) {
    while (input[index] === space) {
        index += 1;
    }
    return index;
};

var parseExpression = function (input, index) {
    index = skipWhiteSpace(input, index);

    if (input[index] === startParenthesis) {
        return parseList(input, index + 1);
    } else {
        return parseAtom(input, index);
    }
};

var parseList = function (input, index) {
    var list = Immutable.List();

    while (index < input.length && input[index] !== endParenthesis) {
        var expression = parseExpression(input, index);
        list = list.push(expression.ast);
        index = skipWhiteSpace(input, expression.nextIndex);
    }

    if (index === input.length) {
        return {error: new Error('Unbalanced parenthesis')};
    }

    return {ast: list, nextIndex: index + 1};
};

var parseAtom = function (input, index) {
    var start = index;
    while (index < input.length
        && input[index] !== space
        && input[index] !== endParenthesis) {
        index += 1;
    }
    return {ast: input.substring(start, index), nextIndex: index};
};

module.exports.parse = function (input) {
    var result = parseExpression(input, 0);
    var nextIndex = skipWhiteSpace(input, result.nextIndex);
    if (nextIndex < input.length) {
        return {error: new Error('Unbalanced parenthesis')};
    }
    return result;
};
