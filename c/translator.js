
var Immutable = require('immutable');

var state = require('../translation/state');
var functions = require('../translation/functions');
var math = require('../translation/math');
var operators = require('../translation/operators');
var symbols = require('../translation/symbols');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var translateAst = require('../translation/translate-ast');
var variable = translateAst.variable;

var infer = require('../type-inference/infer');
var Type = require('../type-inference/type');

var typeLookupTable = {
    'integer': 'int'
};

var translateType = function translateType (context, type) {
    if (type.isLambda) {
        var typedef = 'typedef ';
        context = translateType(context, type.returnType);
        typedef += state.expression(context) + ' ';

        context = state.incrementUniqueId(context);
        var name = 'reuse_gen_type' + state.uniqueId(context);

        typedef += '(*' + name + ')(';
        for (var index = 0; index < type.parameterTypes.size; ++index) {
            context = translateType(context, type.parameterTypes.get(index));
            if (index > 0) {
                typedef += ', ';
            }
            typedef += state.expression(context);
        }
        typedef += ');\n';

        context = state.addDefinition(context, Immutable.List.of(typedef));
        return state.setExpression(context, name);
    } else {
        if (type.name.substr(0, 1) == ' ') {
            return state.setExpression(context, 'anonymous_type_' + type.name.substr(1));
        }
        return state.setExpression(context, typeLookupTable[type.name]);
    }
};

var specializeLambda = function (context, lambda, type, constraints) {
    context = state.incrementUniqueId(context);
    var id = 'reuse_gen_lambda' + state.uniqueId(context);

    var arguments = ast.child(lambda, 1);
    var body = ast.child(lambda, 2);

    var parts = Immutable.List();

    context = translateType(context, type.returnType);
    parts = parts.push(state.expression(context));
    parts = parts.push(' ' + id + '(');
    for (var index = 0; index < ast.size(arguments); ++index) {
        var argument = ast.child(arguments, index);
        if (index > 0) {
            parts = parts.push(', ');
        }
        context = translateType(context, type.parameterTypes.get(index));
        parts = parts.push(state.expression(context));
        parts = parts.push(' ');
        parts = parts.push(ast.value(argument));
    }
    parts = parts.push(') { return ');
    context = translateExpression(context, body, type.returnType, constraints);
    parts = parts.push(state.expression(context));
    parts = parts.push('; }\n');

    context = state.setExpression(context, id);
    return state.addDefinition(context, parts);
};

var translateExpression = function (context, expression, type, constraints) {
    var translateExpressionWithoutType = function (context, expression) {
        return translateExpression(context, expression, type, constraints);
    };
    return translateAst(context, expression, []
        .concat(operators.infixOperators(translateExpressionWithoutType))
        .concat(math.functions(translateExpressionWithoutType))
        .concat(functions.application(translateExpression, type, constraints, specializeLambda, true))
        .concat(symbols.atom(translateExpressionWithoutType))
    );
};

module.exports.translate = function (expression) {
    var expressionType = Type.constant('integer');
    var context = translateExpression(state.new(), expression, expressionType, operators.constraints);

    return state.definitions(context) + 'int expression() { return ' + state.expression(context) + '; }';
};
