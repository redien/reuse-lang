
var Immutable = require('immutable');

var ast = require('../parser/ast');
var Type = require('./type');

module.exports.type = function (expression, constraints) {
    var constrainResult = module.exports.constraints(expression, constraints);
    var substitutions = module.exports.unify(constrainResult.constraints);
    return module.exports.substitute(constrainResult.type, substitutions);
};

var tryFindingTypeOfVariable = function (variable, constraints) {
    for (var i = 0; i < constraints.size; ++i) {
        var constraint = constraints.get(i);

        if (constraint[0].isVariable && constraint[0].name === ast.value(variable)) {
            return constraint[1];
        }
    }

    return Type.variable(ast.value(variable));
};

var isNumeric = function (name) {
    return name.match(/^\d+$/) !== null;
};

var largestIdInType = function (largestId, type) {
    if (type.isVariable && type.name.substr(0, 1) === ' ') {
        var id = parseInt(type.name.substr(1), 10);
        return id > largestId ? id : largestId;

    } else if (type.isLambda) {
        largestId = largestIdInType(largestId, type.returnType);
        return type.parameterTypes.reduce(largestIdInType, largestId);

    } else {
        return largestId;
    }
};

var findUnusedVariableId = function (constraints) {
    return constraints.reduce(function (largestId, constraint) {
        largestId = largestIdInType(largestId, constraint[0]);
        return largestIdInType(largestId, constraint[1]);
    }, 0) + 1;
};

var anonymousType = function (constraints) {
    var id = findUnusedVariableId(constraints);
    // User-defined types cannot contain spaces.
    // Having space as the first character avoids name collisions.
    return Type.variable(' ' + id);
};

var constraintsForLambda = function (expression, constraints) {
    var parameters = ast.child(expression, 1);

    var parameterTypes = Immutable.List();
    for (var index = 0; index < ast.size(parameters); ++index) {
        var parameterName = ast.value(ast.child(parameters, index));
        var parameterType = anonymousType(constraints);

        constraints = constraints.push([Type.variable(parameterName), parameterType]);
        parameterTypes = parameterTypes.push(parameterType);
    }

    var body = ast.child(expression, 2);
    var result = _constraints(body, constraints);
    var returnType = result.type;

    return {
        type: (returnType.isError) ? returnType : Type.lambda(parameterTypes, returnType),
        constraints: result.constraints
    };
};

var constraintsForApplication = function (expression, constraints) {
    var resultConstraints = Immutable.List();

    var lambda = ast.child(expression, 0);
    var result = _constraints(lambda, constraints);
    var lambdaType = result.type;
    resultConstraints = resultConstraints.concat(result.constraints);

    var argumentTypes = Immutable.List();
    for (var index = 1; index < ast.size(expression); ++index) {
        var argument = ast.child(expression, index);
        var result = _constraints(argument, constraints);

        var argumentType = result.type;
        argumentTypes = argumentTypes.push(argumentType);
        resultConstraints = resultConstraints.concat(result.constraints);
    }

    var returnType = anonymousType(constraints);

    resultConstraints = resultConstraints.push([lambdaType, Type.lambda(argumentTypes, returnType)]);

    return {
        type: returnType,
        constraints: resultConstraints
    };
};

var _constraints = function _constraints (expression, constraints) {
    if (ast.isList(expression)) {
        var firstExpression = ast.child(expression, 0);

        if (ast.isAtom(firstExpression) && ast.value(firstExpression) === 'lambda') {
            return constraintsForLambda(expression, constraints);
        } else {
            return constraintsForApplication(expression, constraints);
        }

    } else if (isNumeric(ast.value(expression))) {
        return {
            type: Type.constant('integer'),
            constraints: Immutable.List()
        };

    } else {
        return {
            type: tryFindingTypeOfVariable(expression, constraints),
            constraints: Immutable.List()
        };
    }
};

module.exports.constraints = _constraints;

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
                    return [substitution[0], module.exports.substitute(substitution[1], constraintAsSubstitution)];
                };
                var substituteBoth = function (substitution) {
                    return [module.exports.substitute(substitution[0], constraintAsSubstitution), module.exports.substitute(substitution[1], constraintAsSubstitution)];
                };

                constraints = constraints.map(substituteBoth);
                substitutions = substitutions.map(substituteRightHand);
                substitutions = substitutions.push(constraint);
            }

        } else if (second.isVariable) {
            constraints = constraints.push([second, first]);

        } else if (first.isLambda) {
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

module.exports.substitute = function substitute (type, substitutions) {
    if (type.isVariable) {
        var matchingSubstitutions = substitutions.filter(function (substitution) {
            return type.name === substitution[0].name;
        });

        if (matchingSubstitutions.size > 0) {
            return matchingSubstitutions.first()[1];
        } else {
            return type;
        }

    } else if (type.isLambda) {
        var parameterTypes = type.parameterTypes.map(function (type) {
            return substitute(type, substitutions);
        });
        var returnType = substitute(type.returnType, substitutions);
        return Type.lambda(parameterTypes, returnType);

    } else {
        return type;
    }
};
