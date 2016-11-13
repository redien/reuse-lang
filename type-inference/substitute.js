
var Type = require('./type');

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
