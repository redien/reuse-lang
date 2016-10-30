
var state = require('./state');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var translateAst = require('../translation/translate-ast');
var variable = translateAst.variable;

var functions = require('./functions');

module.exports.functions = function (translateExpression, type, constraints, specializeLambda) {
    var translater = function (name) {
        return function (context, variables, expression, locationInformation) {
            context = translateExpression(context, variables.get('first'), locationInformation ? locationInformation.get(1) : null);
            var first = state.expression(context);
            context = translateExpression(context, variables.get('second'), locationInformation ? locationInformation.get(2) : null);
            var second = state.expression(context);

            return state.setExpression(context, name + '(' + first + ', ' + second + ')');
        };
    };
    return [
        list(atom('max'), variable('first'), variable('second')),
            translater('max'),
        list(atom('min'), variable('first'), variable('second')),
            translater('min')
    ];
};
