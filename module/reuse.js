
var parser = require('../parser/parser');

var translate = function (language, expression) {
    var result = parser.parse(expression);
    if (result.error) {
        return {error: result.error};
    } else {
        return {error: null, source: require('../' + language + '/translator').translate(result.ast)};
    }
};
module.exports.translate = translate;
