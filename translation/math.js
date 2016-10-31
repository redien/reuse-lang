
var state = require('./state');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var translateAst = require('../translation/translate-ast');
var variable = translateAst.variable;

var functions = require('./functions');

module.exports.functions = function (translateExpression, type, constraints, specializeLambda) {
    var translater = function (name) {
        return function (context, variables, expression) {
            context = translateExpression(context, variables.get('first'));
            var first = state.expression(context);
            context = translateExpression(context, variables.get('second'));
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
