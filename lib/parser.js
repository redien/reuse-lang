
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

var ast = require('../lib/ast-builder');

var UNBALANCED_PARENTHESES_ERROR = {error: new Error('unbalanced_parentheses')};
var EXPECTED_WHITESPACE_ERROR = {error: new Error('expected_whitespace')};

var isWhitespace = function (character) {
    return character === ' ' ||
           character === '\t' ||
           character === '\n' ||
           character === '\r' ||
           character === '\u00A0' ||
           character === '\u1680' ||
           character === '\u180E' ||
           character === '\u2000' ||
           character === '\u2001' ||
           character === '\u2002' ||
           character === '\u2003' ||
           character === '\u2004' ||
           character === '\u2005' ||
           character === '\u2006' ||
           character === '\u2007' ||
           character === '\u2008' ||
           character === '\u2009' ||
           character === '\u200A' ||
           character === '\u200B' ||
           character === '\u202F' ||
           character === '\u205F' ||
           character === '\u3000' ||
           character === '\uFEFF';
};

var isPartOfAtom = function (character) {
    return !isWhitespace(character) && character !== '(' && character !== ')';
};

var consume = function (predicate, program, state) {
    if (state.index < program.length && predicate(program[state.index])) {
        state.index++;
        return true;
    }
};

var consumeToken = function (token, program, state) {
    return consume(function (character) { return character === token; }, program, state);
}

var updateLineNumber = function (program, state) {
    if (state.index < program.length && program[state.index] === '\n') {
        state.line += 1;
        state.lineStart = state.index + 1;
    }
};

var consumeSpace = function (program, state) {
    updateLineNumber(program, state);
    return consume(isWhitespace, program, state);
}

var consumePartOfAtom = function(program, state) {
    return consume(isPartOfAtom, program, state);
}

var parseAtomValue = function (program, state) {
    var start = state.index;
    while (consumePartOfAtom(program, state)) {}
    return program.slice(start, state.index);
};

var addToParent = function (parentList, child) {
    child.parent = parentList;
    parentList.elements.push(child);
};

var createNewAtomInParent = function (parentList, value) {
    var atom = ast(value);
    addToParent(parentList, atom);
    return atom;
};

var createNewListInParent = function (parentList) {
    var list = ast([]);
    addToParent(parentList, list);
    return list;
};

exports.parse = function (program) {
    var openBraces = 0;
    var root = ast([]);
    var current = root;
    var state = { index: 0, line: 1, lineStart: 0 };

    while (state.index < program.length) {
        if (consumeToken('(', program, state)) {
            var list = createNewListInParent(current);
            current = list;
            openBraces += 1;

        } else if (consumeToken(')', program, state)) {
            if (current === root) {
                return UNBALANCED_PARENTHESES_ERROR;
            }
            current = current.parent;
            openBraces -= 1;

            if (state.index < program.length && (isPartOfAtom(program[state.index]) || program[state.index] === '(')) {
                return EXPECTED_WHITESPACE_ERROR;
            }

        } else if (consumeSpace(program, state)) {
        } else {
            var column = (state.index - state.lineStart) + 1;
            var value = parseAtomValue(program, state);
            var atom = createNewAtomInParent(current, value);
            atom.line = state.line;
            atom.column = column;

            if (state.index < program.length && program[state.index] == '(') {
                return EXPECTED_WHITESPACE_ERROR;
            }
        }
    }

    if (openBraces !== 0) {
        return UNBALANCED_PARENTHESES_ERROR;
    }

    return root;
};
