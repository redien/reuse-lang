
var parser = require('../parser/parser');
var ast = require('../parser/ast');
var infer = require('../type-inference/infer');
var Immutable = require('immutable');

var translate = function (language, expression) {
    var parseResult = parser.parse(expression);
    if (parseResult.error) {
        return {
            errors: Immutable.List.of(parseResult.error)
        };
    }

    var expression = ast.child(parseResult.ast, 0);

    return require('../' + language + '/translator').translate(expression);
};
module.exports.translate = translate;
