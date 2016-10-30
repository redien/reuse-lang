
var Immutable = require('immutable');
var state = require('./state');

var infer = require('../type-inference/infer');
var Type = require('../type-inference/type');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var translateAst = require('../translation/translate-ast');
var variable = translateAst.variable;

module.exports.application = function (translateExpression,
                                       type,
                                       constraints,
                                       specializeLambda,
                                       ampersantBeforeLambdaArgument) {
    return [
        list(atom('lambda'), variable('arguments', 'list'), variable('body')),
            function (context, variables, lambda, locationInformation) {
                var arguments = ast.listChild(lambda, 1);
                for (var index = 0; index < ast.listSize(arguments); ++index) {
                    var argument = ast.listChild(arguments, index);
                    constraints = constraints.push([
                        Type.variable(ast.atomValue(argument)), type.parameterTypes.get(index)
                    ]);
                }

                return specializeLambda(context, lambda, locationInformation, type, constraints);
            },

        variable('_', 'list'),
            function (context, variables, expression, locationInformation) {
                var lambda = ast.listChild(expression, 0);
                var result = infer.constraints(lambda, constraints);
                var lambdaType = result.type;
                constraints = constraints.concat(result.constraints);
                var argumentTypes = Immutable.List();

                for (var index = 1; index < ast.listSize(expression); ++index) {
                    var argument = ast.listChild(expression, index);
                    result = infer.constraints(argument, constraints);
                    var argumentType = result.type;
                    constraints = constraints.concat(result.constraints);

                    argumentTypes = argumentTypes.push(argumentType);

                    constraints = constraints.push([
                        argumentType,
                        lambdaType.parameterTypes.get(index - 1)
                    ]);
                }

                var substitutions = infer.unify(constraints);
                lambdaType = infer.substitute(lambdaType, substitutions);
                argumentTypes = argumentTypes.map(function (type) {
                    return infer.substitute(type, substitutions);
                });

                context = translateExpression(context, lambda, locationInformation ? locationInformation.get(0) : null, lambdaType, constraints);

                var parts = Immutable.List();
                parts = parts.push(state.expression(context));
                parts = parts.push('(');
                for (var index = 1; index < ast.listSize(expression); ++index) {
                    var argument = ast.listChild(expression, index);
                    var argumentType = argumentTypes.get(index - 1);
                    context = translateExpression(context, argument, locationInformation ? locationInformation.get(index) : null, argumentType, constraints);

                    if (index > 1) { parts = parts.push(', '); }

                    if (ampersantBeforeLambdaArgument && argumentType.isLambda) { parts = parts.push('&'); }

                    parts = parts.push(state.expression(context));
                }
                parts = parts.push(')');

                return state.setExpression(context, parts);
            }
    ];
};
