
var Immutable = require('immutable');
var substitute = require('./substitute');

var NOT_UNIFIED = 'not unified';
module.exports.NOT_UNIFIED = NOT_UNIFIED;

var unify = function (constraints, substitutions) {
    while (constraints.size > 0) {
        var constraint = constraints.get(0);
        var first = constraint[0];
        var second = constraint[1];
        constraints = constraints.delete(0);

        if (first.isVariable) {
            if (!second.isVariable || first.name !== second.name) {
                var constraintAsSubstitution = Immutable.List.of(constraint);

                var substituteRightHand = function (substitution) {
                    return [substitution[0], substitute.substitute(substitution[1], constraintAsSubstitution)];
                };
                var substituteBoth = function (substitution) {
                    return [substitute.substitute(substitution[0], constraintAsSubstitution), substitute.substitute(substitution[1], constraintAsSubstitution)];
                };

                constraints = constraints.map(substituteBoth);
                substitutions = substitutions.map(substituteRightHand);
                substitutions = substitutions.push(constraint);
            }

        } else if (second.isVariable) {
            constraints = constraints.push([second, first]);

        } else if (first.isLambda) {
            if (!second.isLambda) {
                return NOT_UNIFIED;
            }

            constraints = constraints.push([first.returnType, second.returnType]);
            for (var parameterIndex = 0; parameterIndex < first.parameterTypes.size; ++parameterIndex) {
                constraints = constraints.push([
                    first.parameterTypes.get(parameterIndex),
                    second.parameterTypes.get(parameterIndex)
                ]);
            }
        } else if (first.isConstant && second.isConstant) {
            if (first.name !== second.name) {
                return NOT_UNIFIED;
            }
        }
    }

    return substitutions;
};

module.exports.unify = function (constraints) {
    return unify(constraints, Immutable.List());
};
