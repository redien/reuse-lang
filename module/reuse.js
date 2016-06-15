
var parser = require('../parser/parser');
var ast = require('../parser/ast');

var translate = function (language, expression) {
    var result = parser.parse(expression);
    if (result.error) {
        return {error: result.error};
    } else {
        return {error: null, source: require('../' + language + '/translator').translate(ast.listChild(result.ast, 0))};
    }
};
module.exports.translate = translate;
