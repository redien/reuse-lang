
var parser = require('../parser/parser');

var translate = function (language, expression) {
    var parsedExpression = parser.parse(expression);
    return require('../' + language + '/translator').translate(parsedExpression);
};
module.exports.translate = translate;
