
var ast = require('../parser/ast');
var match = require('../translation/match-ast');
var atom = match.atom;
var list = match.list;
var variable = match.variable;

var argumentListFromList = function (list, translate) {
    var argumentList = '(';
    for (var index = 1; index < ast.listSize(list); index += 1) {
        if (index > 1) {
            argumentList += ', ';
        }
        argumentList += translate(ast.listChild(list, index));
    }
    argumentList += ')';
    return argumentList;
};

module.exports = function (translate) {
    return [
        variable('list', 'list'),
        (variables) => {
            var list = variables.get('list');
            return translate(ast.listChild(list, 0)) + argumentListFromList(list, translate);
        },
    ];
};
