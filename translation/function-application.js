
var ast = require('../parser/ast');
var state = require('./state');
var match = require('./match-ast');
var atom = match.atom;
var list = match.list;
var variable = match.variable;

module.exports = function (translate) {
    return [
        variable('list', 'list'),
        (variables) => {
            var list = variables.get('list');
            var definitions = '';

            var argumentList = '(';
            for (var index = 1; index < ast.listSize(list); index += 1) {
                if (index > 1) {
                    argumentList += ', ';
                }
                var translatedExpression = translate(ast.listChild(list, index));
                argumentList += state.expression(translatedExpression);
                definitions += state.definitions(translatedExpression);
            }
            argumentList += ')';

            var translatedFunction = translate(ast.listChild(list, 0));

            return state.new(state.expression(translatedFunction) + argumentList, state.definitions(translatedFunction) + definitions);
        },
    ];
};
