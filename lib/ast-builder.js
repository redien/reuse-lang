
// reuse-lang - a pure functional lisp-like language for writing
// reusable algorithms in an extremely portable way.
//
// Written in 2015 by Jesper Oskarsson jesosk@gmail.com
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

var parseAst = function (expression, column) {
    column = column || 0;

    if (Array.isArray(expression)) {
        return parseArray(expression, column);
    } else {
        return parseAtom(expression, column);
    }
};

var parseArray = function (expression, column) {
    var elements = null;

    // Add first bracket to column index
    column += 1;

    var expressionArray = [];
    var index;
    for (index = 0; index < expression.length; ++index) {
        var element = expression[index];
        var parsedAst = parseAst(element, column);
        expressionArray.push(parsedAst);

        column = parsedAst._columnEnd + 1;
    }

    var index;
    for (index = expressionArray.length - 1; index >= 0; --index) {
        var parsedAst = expressionArray[index];
        elements = [parsedAst, elements];
    }

    var result = [0, elements];

    Object.defineProperty(result, '_columnEnd', {value: column, enumerable: false});

    return result;
};

var parseAtom = function (expression, column) {
    var result = [1, [expression, [1, [column, null]]]];

    Object.defineProperty(result, '_columnEnd', {value: column + expression.length, enumerable: false});

    return result;
};

module.exports = parseAst;

module.exports.kind = function (expression) {
    if (expression[0] === 0) {
        return 'list';
    } else {
        return 'atom';
    }
};

module.exports.value = function (atom) {
    return atom[1][0];
};

module.exports.line = function (atom) {
    return atom[1][1][0];
};

module.exports.setLine = function (atom, line) {
    atom[1][1] = [line, atom[1][1][1]];
};

module.exports.column = function (atom) {
    return atom[1][1][1][0];
};

module.exports.setColumn = function (atom, column) {
    atom[1][1][1] = [column, atom[1][1][1][1]];
};

module.exports.expression = function (list, index) {
    while (index >= 0) {
        list = list[1];
        index -= 1;
    }
    return list[0];
};

module.exports.count = function (list) {
    if (list === null) {
        return 0;
    } else {
        var count = 0;
        while (list !== null) {
            list = list[1];
            count++;
        }
        return count - 1;
    }
};

module.exports.push = function (list, expression) {
    while (list[1] !== null) {
        list = list[1];
    }
    list[1] = [expression, null];
};
