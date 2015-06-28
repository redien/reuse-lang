
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

module.exports = function serialize (ast) {
    if (ast.kind === 'atom') {
        return ast.value;
    } else {
        var str = '(';
        var index;
        for (index = 0; index < ast.elements.length; ++index) {
            var element = ast.elements[index];
            if (index !== 0) {
                str += ' ';
            }
            str += serialize(element);
        }

        return str + ')';
    }
};