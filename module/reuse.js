
var parser = require('../parser/parser');
var ast = require('../parser/ast');
var infer = require('../type-inference/infer');

var translate = function (language, expression) {
    var parseResult = parser.parse(expression);
    if (parseResult.error) {
        return parseResult;
    }

    var expression = ast.child(parseResult.ast, 0);

    return {
        error: null,
        source: require('../' + language + '/translator').translate(expression)
    };
};
module.exports.translate = translate;
