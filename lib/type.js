
// reuse-lang - a pure functional lisp-like language for writing
// reusable business-logic in an extremely portable way.
//
// Written in 2015 by Jesper Oskarsson jesosk@gmail.com
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

var type = require('../lib/type');

exports.constant = function (name) {
    return {
        kind: 'constant',
        name: name
    };
};

exports.tuple = function (first, second) {
    return {
        kind: 'tuple',
        first: first,
        second: second
    };
};

exports.list = function (type) {
    return {
        kind: 'list',
        type: type
    };
};

exports.variable = function () {
    return {
        kind: 'variable'
    };
};

exports.equals = function equals (a, b) {
    if (a.kind !== b.kind) {
        return false;
    }

    if (a.kind === 'list') {
        return equals(a.type, b.type);
    } else if (a.kind === 'tuple') {
        return equals(a.first, b.first) && equals(a.second, b.second);
    } else if (a.kind === 'variable') {
        return a === b;
    } else {
        return a.name === b.name;
    }

    return false;
};