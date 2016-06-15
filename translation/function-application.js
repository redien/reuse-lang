
var ast = require('../parser/ast');
var match = require('../translation/match-ast');
var atom = match.atom;
var list = match.list;
var variable = match.variable;

module.exports = function (translate) {
    return [
        list(variable('f'), variable('a'), variable('b')),
        (variables) => ast.atomValue(variables.get('f')) + '(' + ast.atomValue(variables.get('a')) + ', ' + ast.atomValue(variables.get('b')) + ')'
    ];
};
