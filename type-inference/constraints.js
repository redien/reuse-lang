
var Immutable = require('immutable');

var ast = require('../parser/ast');
var Type = require('./type');

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

var _constraints = function (expression, constraints) {
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
