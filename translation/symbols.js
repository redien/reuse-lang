
var symbols = module.exports;

var state = require('./state');
var ast = require('../parser/ast');
var match = require('./match-ast');
var variable = match.variable;

symbols.atom = function (translateExpression) {
    return [
        variable('atom', 'atom'),
            (translationState, variables) => state.setExpression(translationState, ast.atomValue(variables.get('atom')))
    ];
};
