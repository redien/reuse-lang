
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

var UNBALANCED_PARENTHESES_ERROR = {error: new Error('unbalanced-parentheses')};

var isSpace = function (character) {
    return character === ' ' ||
           character === '\t' ||
           character === '\n' ||
           character === '\r';
};

var isPartOfAtom = function (character) {
    return !isSpace(character) && character !== ')';
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

var consumeSpace = function (program, state) {
    return consume(isSpace, program, state);
}

var consumePartOfAtom = function(program, state) {
    return consume(isPartOfAtom, program, state);
}

var parseAtom = function (program, state) {
    var start = state.index;
    while (consumePartOfAtom(program, state)) {}
    return ast(program.slice(start, state.index));
};

exports.parse = function (program) {
    var root = null,
        current = null,
        openBraces = 0,
        value = null;

    var state = {
        index: 0
    };

    if (program.length === 0) {
        return {error: null, value: null};
    }

    while (state.index < program.length) {
        if (consumeToken('(', program, state)) {
            var list = ast([]);
            list.parent = current;

            if (current) {
                current.elements.push(list);
            }

            current = list;
            if (root === null) {
                root = list;
            }

            openBraces += 1;

        } else if (consumeToken(')', program, state)) {
            if (current === null) {
                return UNBALANCED_PARENTHESES_ERROR;
            }
            current = current.parent;
            openBraces -= 1;

        } else if (consumeSpace(program, state)) {
        } else {
            var atom = parseAtom(program, state);

            if (!current) {
                value = atom;
            } else {
                current.elements.push(atom);
                atom.parent = current;
            }
        }
    }

    if (openBraces !== 0) {
        return UNBALANCED_PARENTHESES_ERROR;
    }

    return {error: null, value: root || value};
};
