
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

exports.parse = function (program) {
    var index = 0,
        root = null,
        current = null,
        openBraces = 0,
        value = null;
    
    if (program.length === 0) {
        return {error: null, value: null};
    }
    
    while (index < program.length) {
        if (program[index] === '(') {
            var list = {kind: 'list', elements: []};
            list.parent = current;
            
            if (current) {
                current.elements.push(list);
            }
            
            current = list;
            if (root === null) {
                root = list;
            }
            
            openBraces += 1;
            
            index += 1;

        } else if (program[index] === ')') {
            if (current === null) {
                return {error: new Error('unbalanced-parentheses')};
            }
            current = current.parent;
            openBraces -= 1;
            index += 1;
        
        } else if (program[index] === ' ' ||
                   program[index] === '\t' ||
                   program[index] === '\n' ||
                   program[index] === '\r') {
            index += 1;
        
        } else {
            var start = index;
            while (index < program.length &&
                   program[index] !== ' ' &&
                   program[index] !== '\t' &&
                   program[index] !== '\n' &&
                   program[index] !== '\r' &&
                   program[index] !== ')') {
                index += 1;
            }

            var atom = {kind: 'atom', value: program.slice(start, index)};
            
            if (!current) {
                value = atom;
            } else {
                current.elements.push(atom);
                atom.parent = current;
            }
        }
    }
    
    if (openBraces !== 0) {
        return {error: new Error('unbalanced-parentheses')};
    }

    return {error: null, value: root || value};
};
