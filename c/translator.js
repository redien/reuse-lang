
var state = require('../translation/state');
var functions = require('../translation/functions');
var operators = require('../translation/operators');

var ast = require('../parser/ast');
var atom = ast.atom;
var list = ast.list;

var match = require('../translation/match-ast');
var variable = match.variable;

var translateExpression = function translateExpression (parsedExpression) {
    return match(parsedExpression, [
            list(atom('lambda'), variable('arguments', 'list'), variable('expression')),
            (variables) => state.new('lambda', 'int lambda() { return ' + ast.atomValue(variables.get('expression')) + '; }\n'),
        ].concat(
            operators.infixOperatorsForLanguageWithInt32(translateExpression)
        ).concat(
            functions.application(translateExpression)
        ).concat([
            variable('atom', 'atom'), (variables) => state.new(ast.atomValue(variables.get('atom')), '')
        ])
    );
};

module.exports.translate = function (parsedExpression) {
    var translatedExpression = translateExpression(parsedExpression);
    return state.definitions(translatedExpression) + 'int expression() { return ' + state.expression(translatedExpression) + '; }';
};
