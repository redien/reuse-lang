
module.exports.type = function (expression, constraints) {
    var constrainResult = module.exports.constraints(expression, constraints);
    var substitutions = module.exports.unify(constrainResult.constraints);
    return module.exports.substitute(constrainResult.type, substitutions);
};

module.exports.constraints = require('./constraints').constraints;

module.exports.NOT_UNIFIED = require('./unify').NOT_UNIFIED;
module.exports.unify = require('./unify').unify;

module.exports.substitute = require('./substitute').substitute;
