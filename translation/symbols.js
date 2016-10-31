
var symbols = module.exports;

var Immutable = require('immutable');

var state = require('./state');
var ast = require('../parser/ast');
var translateAst = require('../translation/translate-ast');
var variable = translateAst.variable;

symbols.atom = function (translateExpression) {
    return [
        variable('atom', 'atom'),
            function (context, variables) {
                var parts = Immutable.List();
                parts = parts.push(ast.value(variables.get('atom')));
                return state.setExpression(context, parts);
            }
    ];
};
