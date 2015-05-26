
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

var parseAst = function (expression) {
    if (Array.isArray(expression)) {
        return parseArray(expression);
    } else {
        return parseAtom(expression);
    }
};

var parseArray = function (expression) {
    var elements = [];

    var index;
    for (index = 0; index < expression.length; ++index) {
        var element = expression[index];
        elements.push(parseAst(element));
    }

    return {
        kind: 'list',
        elements: elements
    };
};

var parseAtom = function (expression) {
    return {
        kind: 'atom',
        value: expression
    };
};

module.exports = parseAst;
