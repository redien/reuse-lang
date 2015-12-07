
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

var pt = require('./parse-tree');

var parseAst = function (expression, column) {
    if (Array.isArray(expression)) {
        return parseArray(expression, column);
    } else {
        return parseAtom(expression, column);
    }
};

var parseArray = function (expression, column) {
    var list = pt.parse_tree_list();

    // Add first bracket to column index
    column += 1;

    var index;
    for (index = 0; index < expression.length; ++index) {
        var element = expression[index];
        var parsedAst = parseAst(element, column);

        list = pt.parse_tree_push(list, parsedAst.value);
        column = parsedAst.newColumn + 1;
    }

    return {
        newColumn: column,
        value: list
    };
};

var parseAtom = function (expression, column) {
    return {
        newColumn: column + expression.length,
        value: pt.parse_tree_atom(expression, 1, column)
    };
};

module.exports = function (expression) {
    return parseAst(expression, 0).value;
};

module.exports.kind = function (expression) {
    return pt.parse_tree_kind(expression);
};

module.exports.value = function (atom) {
    return pt.parse_tree_value(atom);
};

module.exports.line = function (atom) {
    return pt.parse_tree_line(atom);
};

module.exports.column = function (atom) {
    return pt.parse_tree_column(atom);
};

module.exports.expression = function (list, index) {
    return pt.parse_tree_child(list, index);
};

module.exports.count = function (list) {
    return pt.parse_tree_count(list);
};
