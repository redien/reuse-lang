
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

var bindArgumentsToParameters = function (arguments, parameters, parentScope) {
    var map = {
        _parentScope: parentScope
    };
    for (var i = 0; i < parameters.length; ++i) {
        map[parameters[i].value] = arguments[i];
    }
    return map;
};

var lookupVariableInScope = function (variable, scope) {
    if (scope[variable]) {
        return scope[variable];
    } else if (scope._parentScope) {
        return lookupVariableInScope(variable, scope._parentScope);
    }
};

var isInteger = function (value) {
    return value.match(/^-?\d+$/) !== null;
};

var evaluate = function evaluate(parsedProgram, scope) {
    if (parsedProgram.kind === 'list') {
        if (parsedProgram.elements.length === 0) {
            // ()
            return {error: null, value: []};
        
        } else {
            var first = parsedProgram.elements[0];
            if (first.kind === 'atom' && first.value === 'lambda') {
                // Construct function
                // (lambda () x)
                // (lambda (x) x)
                // (lambda (x y) y)
                // (lambda (x y) x)

                var parameters = parsedProgram.elements[1].elements;
                var expression = parsedProgram.elements[2];

                var f = {
                    kind: 'function',
                    parameters: parameters,
                    expression: expression,
                    scope: scope
                };

                return {error: null, value: f};

            } else if (first.kind === 'atom' && first.value === 'head') {
                return {error: null, value: []};
                
            } else if (first.kind === 'atom' && first.value === 'list') {
                // (list x y)

                var head = evaluate(parsedProgram.elements[1], scope);
                if (head.error) { return head; }

                var tail = evaluate(parsedProgram.elements[2], scope);
                if (tail.error) { return tail; }

                return {
                    error: null,
                    value: [
                        head.value,
                        tail.value
                    ]
                };

            } else {
                // Eval function
                // (f)
                // (f x)
                // (f x y)

                var lambda = parsedProgram.elements[0];
                var arguments = parsedProgram.elements.slice(1);
                var result = evaluate(lambda, scope);
                if (result.error) {
                    return result;
                }

                var f = result.value;
                scope = bindArgumentsToParameters(
                    arguments,
                    f.parameters,
                    f.scope
                );
                return evaluate(f.expression, scope);
            }
        }
    } else {
        if (isInteger(parsedProgram.value)) {
            // 31
            // -2

            return {error: null, value: parseInt(parsedProgram.value)};

        } else {
            // x
            // f

            var lookup = lookupVariableInScope(parsedProgram.value, scope);
            return evaluate(lookup, scope);
        }
    }
};

exports.evaluate = function (parsedProgram, callback) {
    return evaluate(parsedProgram, {});
};
