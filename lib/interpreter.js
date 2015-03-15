var bindArgumentsToParameters = function (arguments, parameters, scope) {
    var map = {
        _parentScope: scope
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

var evaluate = function evaluate(parsedProgram, scope) {
    if (parsedProgram.kind === 'list') {
        if (parsedProgram.elements.length === 0) {
            // ()
            return {error: null, value: null};
        
        } else {
            var first = parsedProgram.elements[0];
            if (first.kind === 'atom') {
                if (first.value === 'lambda') {
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
                } else if (first.value === 'tuple') {
                    
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
                }

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
        if (parsedProgram.value.match(/^-?\d+$/)) {
            // 31
            // -2
            return {error: null, value: parseInt(parsedProgram.value)};
        } else {
            // x
            // var
            // f
            return evaluate(lookupVariableInScope(parsedProgram.value, scope), scope);
        }
    }
};

exports.evaluate = function (parsedProgram, callback) {
    var result = evaluate(parsedProgram, {});
    callback(result.error, result.value);
};
