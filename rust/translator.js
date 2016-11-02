
var Immutable = require('immutable');

var state = require('../translation/state');
var functions = require('../translation/functions');
var math = require('../translation/math');
var operators = require('../translation/operators');
var symbols = require('../translation/symbols');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var matchAst = require('../parser/match-ast');
var variable = matchAst.variable;

var infer = require('../type-inference/infer');
var Type = require('../type-inference/type');

var typeLookupTable = {
    'integer': 'i32'
};

var translateType = function translateType (type) {
    if (type.isLambda) {
        return '&Fn(' + type.parameterTypes.map(translateType).join(', ') + ') -> ' + translateType(type.returnType);
    } else {
        if (type.name.substr(0, 1) == ' ') {
            return 'anonymous_type_' + type.name.substr(1);
        }
        return typeLookupTable[type.name];
    }
};

var specializeLambda = function (context, lambda, type, constraints) {
    context = state.incrementUniqueId(context);
    var id = 'reuse_gen_lambda' + state.uniqueId(context);

    var arguments = ast.child(lambda, 1);
    var body = ast.child(lambda, 2);

    var parts = Immutable.List();
    parts = parts.push('fn ' + id + '(');
    for (var index = 0; index < ast.size(arguments); ++index) {
        var argument = ast.child(arguments, index);
        if (index > 0) {
            parts = parts.push(', ');
        }
        parts = parts.push(ast.value(argument));
        parts = parts.push(': ');
        parts = parts.push(translateType(type.parameterTypes.get(index)));
    }
    parts = parts.push(') -> ');
    parts = parts.push(translateType(type.returnType));
    parts = parts.push(' { return ');
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
    return matchAst(context, expression, []
        .concat(operators.infixOperators(translateExpressionWithoutType))
        .concat(math.functions(translateExpressionWithoutType))
        .concat(functions.application(translateExpression, type, constraints, specializeLambda, true))
        .concat(symbols.atom(translateExpressionWithoutType))
    );
};

module.exports.translate = function (expression) {
    var expressionType = Type.constant('integer');
    var context = translateExpression(state.new(), expression, expressionType, operators.constraints);

    return state.definitions(context) + 'fn expression() -> i32 { return ' + state.expression(context) + '; }';
};
