
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

var unboundVariableError = new Error('Found unbound variable.');
unboundVariableError.type = 'UnboundVariable';

var isInteger = function (value) {
    return value.match(/^-?\d+$/) !== null;
};

var variableIsDefinedInScope = function variableIsDefinedInScope (variable, scope) {
    if (!scope) {
        return false;
    }
    
    var found = false;
    scope.parameters.forEach(function (parameter) {
        if (parameter.value === variable) {
            found = true;
        }
    });
    
    if (found) {
        return true;
    } else {
        return variableIsDefinedInScope(variable, scope.parent);
    }
};

var validate = function validate(parsedProgram, scope) {
    var error = null;

    if (parsedProgram.kind === 'atom') {
        if (isInteger(parsedProgram.value)) {
            return null;
        }
        
        if (!variableIsDefinedInScope(parsedProgram.value, scope)) {
            error = unboundVariableError;
        }

    } else {
        if (parsedProgram.elements.length === 0) {
            return null;
        }

        var first = parsedProgram.elements[0];
        if (first.kind === 'atom' && first.value === 'lambda') {
            var parameters = parsedProgram.elements[1].elements;
            var newScope = {
                parent: scope,
                parameters: parameters
            };

            return validate(parsedProgram.elements[2], newScope);
        
        } else {
            var arguments = parsedProgram.elements.slice(1);
            
            if (parsedProgram.elements[0].kind === 'list') {
                var parameters = parsedProgram.elements[0].elements[1].elements;

                if (arguments.length > parameters.length) {
                    error = new Error('Too many arguments in function call.');
                    error.type = 'TooManyArguments';
                } else if (arguments.length < parameters.length) {
                    error = new Error('Too few arguments in function call.');
                    error.type = 'TooFewArguments';
                }
            } else {
                parsedProgram.elements.forEach(function (expression) {
                    var result = validate(expression, scope);
                    if (result) {
                        error = result;
                    }
                });
            }
        }
    }

    return error;
};

exports.validate = function (parsedProgram, callback) {
    var error = validate(parsedProgram, {
        parameters: [
            {kind: 'atom', value: 'list'},
            {kind: 'atom', value: 'head'}
        ]
    });
    callback(error);
};
