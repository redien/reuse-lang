var bindArgumentsToParameters = function (arguments, parameters) {
    var map = {};
    for (var i = 0; i < parameters.length; ++i) {
        map[parameters[i].value] = arguments[i];
    }
    return map;
};

var evaluate = function evaluate(parsedProgram, scope) {
    if (parsedProgram.kind === 'list') {
        if (parsedProgram.elements.length === 0) {
            // ()
            return {error: null, value: null};
        
        } else {
            // ((lambda () x)) -> x
            // ((lambda (x) x) z) -> z
            // ((lambda (x y) y) z q) -> q
            // ((lambda (x y) x) z q) -> z

            var arguments = parsedProgram.elements.slice(1);
            var lambda = parsedProgram.elements[0];
            var parameters = lambda.elements[1].elements;
            var expression = lambda.elements[2];

            var scope = bindArgumentsToParameters(
                arguments,
                parameters
            );

            return evaluate(expression, scope);
        }
    } else {
        if (parsedProgram.value.match(/^-?\d+$/)) {
            // 31
            // -2
            return {error: null, value: parseInt(parsedProgram.value)};
        } else {
            return evaluate(scope[parsedProgram.value]);
        }
    }
};

exports.evaluate = function (parsedProgram, callback) {
    var result = evaluate(parsedProgram);
    callback(result.error, result.value);
};
