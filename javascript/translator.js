
module.exports.translate = function (parsedExpression) {
    return parsedExpression.get(1) + ' ' + parsedExpression.get(0) + ' ' + parsedExpression.get(2);
};
