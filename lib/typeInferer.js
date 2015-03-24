
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

exports.infer = function infer(parsedProgram) {
    if (parsedProgram.kind === 'list') {
        if (parsedProgram.elements.length === 0) {
            return {
                type: '()',
                kind: 'list',
                elements: parsedProgram.elements
            };
        } else {
            var first = parsedProgram.elements[0];

            if (first.kind === 'list') {
                var expression = infer(first.elements[2]);
                return {
                    type: expression.type,
                    kind: 'list',
                    elements: [
                        first
                    ]
                };
            }
        }
    } else {
        if (parsedProgram.value.match(/^-?\d+$/)) {
            return {
                type: 'int32',
                kind: 'atom',
                value: parsedProgram.value
            };
        }
    }
};
