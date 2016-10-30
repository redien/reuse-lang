
var parser = require('../parser/parser');
var ast = require('../parser/ast');
var infer = require('../type-inference/infer');

var translate = function (language, expression) {
    var parseResult = parser.parse(expression);
    if (parseResult.error) {
        return parseResult;
    }

    var expression = ast.listChild(parseResult.ast, 0);
    var locationInformation = parseResult.locationInformation.get(0);

    return {
        error: null,
        source: require('../' + language + '/translator').translate(expression, locationInformation)
    };
};
module.exports.translate = translate;
