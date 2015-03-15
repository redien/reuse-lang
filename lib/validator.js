
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

var validate = function validate(parsedProgram, scope) {
    var error;

    if (parsedProgram.kind === 'atom') {
        error = new Error('Found unbound variable.');
        error.type = 'UnboundVariable';
        
    } else {
        var first = parsedProgram.elements[0];
        if (first.kind === 'atom' && first.value === 'lambda') {
            error = new Error('Found unbound variable.');
            error.type = 'UnboundVariable';
        } else {
            var arguments = parsedProgram.elements.slice(1);
            var parameters = parsedProgram.elements[0].elements[1].elements;

            if (arguments.length > parameters.length) {
                error = new Error('Too many arguments in function call.');
                error.type = 'TooManyArguments';
            } else if (arguments.length < parameters.length) {
                error = new Error('Too few arguments in function call.');
                error.type = 'TooFewArguments';
            }
        }
    }

    return error;
};

exports.validate = function (parsedProgram, callback) {
    var error = validate(parsedProgram, {});
    callback(error);
};
