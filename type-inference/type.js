
module.exports.constant = function (name) {
    return {
        isConstant: true,
        name: name
    };
};

module.exports.variable = function (name) {
    return {
        isVariable: true,
        name: name
    };
};

module.exports.lambda = function (parameterTypes, returnType) {
    return {
        isLambda: true,
        parameterTypes: parameterTypes,
        returnType: returnType
    };
};

module.exports.error = function (message) {
    return {
        isError: true,
        message: message
    };
};

module.exports.toString = function toString (type) {
    if (type === null) { return '(# Error: null)'; }
    if (type === undefined) { return '(# Error: undefined)'; }

    if (type.isError) {
        return '(# Error: ' + type.message + ')';
    } else if (type.isLambda) {
        return '(lambda (' + type.parameterTypes.map(toString).join(' ') + ') ' + toString(type.returnType) + ')';
    } else if (type.isVariable) {
        return '(variable ' + type.name + ')';
    } else {
        return type.name;
    }
};
