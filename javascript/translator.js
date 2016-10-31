
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

var dropDecimals = function (operatorTranslator) {
    return function (context, variables) {
        context = operatorTranslator(context, variables);
        var parts = Immutable.List();
        parts = parts.push('Math.floor(');
        parts = parts.push(state.expression(context));
        parts = parts.push(')');
        return state.setExpression(context, parts);
    };
};

var specializeLambda = function (context, lambda, type, constraints) {
    context = state.incrementUniqueId(context);
    var id = 'reuse_gen_lambda' + state.uniqueId(context);

    var arguments = ast.child(lambda, 1);
    var body = ast.child(lambda, 2);

    var parts = Immutable.List();
    parts = parts.push('var ' + id + ' = function (');
    for (var index = 0; index < ast.size(arguments); ++index) {
        var argument = ast.child(arguments, index);
        if (index > 0) {
            parts = parts.push(', ');
        }
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
    return translateAst(context, expression, [
        // Overrides division operator to round off decimal points
        list(atom('/'), variable('a'), variable('b')),
            dropDecimals(operators.infixOperator('/', translateExpression)),
    ]
        .concat(operators.infixOperators(translateExpressionWithoutType))
        .concat(math.functions(translateExpressionWithoutType))
        .concat(functions.application(translateExpression, type, constraints, specializeLambda, false))
        .concat(symbols.atom(translateExpressionWithoutType))
    );
};

module.exports.translate = function (expression) {
    var expressionType = Type.constant('integer');
    var context = translateExpression(state.new(), expression, expressionType, operators.constraints);

    return state.definitions(context) + 'var expression = ' + state.expression(context) + ';';
};
