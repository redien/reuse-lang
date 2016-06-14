
var match = require('../translation/match-ast');
var list = match.list;
var variable = match.variable;

module.exports = function (translate) {
    return [
        list(variable('f'), variable('a'), variable('b')),
        (variables) => variables.get('f') + '(' + variables.get('a') + ', ' + variables.get('b') + ')'
    ];
};
