
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
    column = column || 1;

    if (Array.isArray(expression)) {
        return parseArray(expression, column);
    } else {
        return parseAtom(expression, column);
    }
};

var parseArray = function (expression, column) {
    var elements = [];

    // Add first bracket to column index
    column += 1;

    var index;
    for (index = 0; index < expression.length; ++index) {
        var element = expression[index];
        var parsedAst = parseAst(element, column);
        elements.push(parsedAst);

        column = parsedAst._columnEnd + 1;
    }

    var result = {
        kind: 'list',
        elements: elements
    };

    Object.defineProperty(result, '_columnEnd', {value: column, enumerable: false});

    return result;
};

var parseAtom = function (expression, column) {
    var result = {
        kind: 'atom',
        value: expression,
        line: 1,
        column: column
    };

    Object.defineProperty(result, '_columnEnd', {value: column + expression.length, enumerable: false});

    return result;
};

module.exports = parseAst;
