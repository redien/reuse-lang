
var ast = require('./ast');

var SPACE_CHARACTER = ' ';
var START_PARENTHESIS_CHARACTER = '(';
var END_PARENTHESIS_CHARACTER = ')';

var parenthesisErrorAt = function (index) {
    var error = new Error('Unbalanced parenthesis');
    error.column = index;
    error.line = 0;
    return {error: error};
};

var nextCharacterIs = function (character, input, index) {
    return index < input.length && character === input[index];
};

var skipWhitespace = function (input, index) {
    while (nextCharacterIs(SPACE_CHARACTER, input, index)) {
        index += 1;
    }
    return index;
};

var parseExpression = function (input, index) {
    index = skipWhitespace(input, index);

    if (nextCharacterIs(START_PARENTHESIS_CHARACTER, input, index)) {
        return parseList(input, index + 1);
    } else {
        return parseAtom(input, index);
    }
};

var parseList = function (input, index) {
    var expression = parseListBody(input, index);
    if (expression.error) { return expression; }

    index = expression.nextIndex;

    if (!nextCharacterIs(END_PARENTHESIS_CHARACTER, input, index)) {
        return parenthesisErrorAt(index);
    }

    return {ast: expression.ast, nextIndex: index + 1};
};

var parseListBody = function (input, index) {
    var list = ast.list();

    while (index < input.length && !nextCharacterIs(END_PARENTHESIS_CHARACTER, input, index)) {
        var expression = parseExpression(input, index);
        if (expression.error) { return expression; }

        list = ast.listPush(list, expression.ast);
        index = skipWhitespace(input, expression.nextIndex);
    }

    return {ast: list, nextIndex: index};
};

var parseAtom = function (input, index) {
    var start = index;
    while (index < input.length
        && !nextCharacterIs(SPACE_CHARACTER, input, index)
        && !nextCharacterIs(END_PARENTHESIS_CHARACTER, input, index)) {
        index += 1;
    }

    return {ast: ast.atom(input.substring(start, index)), nextIndex: index};
};

module.exports.parse = function (input) {
    var result = parseListBody(input, 0);
    if (result.error) { return result; }
    index = result.nextIndex;

    if (nextCharacterIs(END_PARENTHESIS_CHARACTER, input, index)) {
        return parenthesisErrorAt(index);
    }

    return result;
};
