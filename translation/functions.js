
var state = require('./state');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var translateAst = require('../translation/translate-ast');
var variable = translateAst.variable;

module.exports.application = function (translateExpression) {
    return [
        variable('list', 'list'),
            (context, variables) => {
                var list = variables.get('list');
                var definitions = '';

                var argumentList = '(';
                for (var index = 1; index < ast.listSize(list); index += 1) {
                    if (index > 1) {
                        argumentList += ', ';
                    }
                    context = translateExpression(context, ast.listChild(list, index));
                    argumentList += state.expression(context);
                }
                argumentList += ')';

                context = translateExpression(context, ast.listChild(list, 0));

                return state.setExpression(context, state.expression(context) + argumentList);
            },
    ];
};

module.exports.argumentList = function (list) {
    var argumentList = '';
    for (var index = 0; index < list.size; index += 1) {
        if (index > 0) { argumentList += ', '; }
        argumentList += ast.atomValue(list.get(index));
    }
    return argumentList;
};
