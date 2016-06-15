
var Immutable = require('immutable');

var space = ' ';
var startParenthesis = '(';
var endParenthesis = ')';

var errorAt = function (index) {
    var error = new Error('Unbalanced parenthesis');
    error.column = index;
    error.line = 0;
    return {error: error};
};

var skipWhiteSpace = function (input, index) {
    while (input[index] === space) {
        index += 1;
    }
    return index;
};

var parseExpression = function (input, index, openedLists) {
    index = skipWhiteSpace(input, index);

    if (input[index] === startParenthesis) {
        return parseList(input, index + 1, openedLists + 1);
    } else {
        return parseAtom(input, index, openedLists);
    }
};

var parseList = function (input, index, openedLists) {
    var list = Immutable.List();

    while (index < input.length && input[index] !== endParenthesis) {
        var expression = parseExpression(input, index, openedLists);
        if (expression.error) {
            return expression;

        } else {
            list = list.push(expression.ast);
            index = skipWhiteSpace(input, expression.nextIndex);
        }
    }

    if (index === input.length) {
        return errorAt(index);
    }

    return {ast: list, nextIndex: index + 1};
};

var parseAtom = function (input, index, openedLists) {
    var start = index;
    while (index < input.length
        && input[index] !== space
        && input[index] !== endParenthesis) {
        index += 1;
    }

    return {ast: input.substring(start, index), nextIndex: index};
};

module.exports.parse = function (input) {
    var list = Immutable.List();
    var index = 0;

    while (index < input.length) {
        if (input[index] === endParenthesis) {
            return errorAt(index);
        }
        var result = parseExpression(input, index, 0);
        if (result.error) { return result; }

        index = skipWhiteSpace(input, result.nextIndex);
        list = list.push(result.ast);
    }

    return {ast: list};
};
