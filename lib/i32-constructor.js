
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

var ast = require('./ast-builder');
var type = require('./type-builder');

var isInteger = function (string) {
    for (var i = 0; i < string.length; ++i) {
        var character = string.substring(i, i + 1);

        if (character !== '0' &&
            character !== '1' &&
            character !== '2' &&
            character !== '3' &&
            character !== '4' &&
            character !== '5' &&
            character !== '6' &&
            character !== '7' &&
            character !== '8' &&
            character !== '9') {
                return false;
        }
    }

    return true;
};

var throwErrorAtAtom = function (error, atom) {
    var error = new Error(error);
    error.line = atom.line;
    error.column = atom.column;
    throw error;
};

module.exports = function (program) {
    if (program.value.substring(0, 1) !== '-' && !isInteger(program.value)) {
        return program;

    } else {
        var parsedInteger = parseInt(program.value, 10);

        if (parsedInteger > 2147483647) {
            throwErrorAtAtom('i32_constant_too_large', program);
        } else if (parsedInteger < -2147483648) {
            throwErrorAtAtom('i32_constant_too_small', program);
        }

        var result = ast(program.value);
        result.isConstant = true;
        result.type = type('i32');
        return result;
    }
};