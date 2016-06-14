
module.exports.infixOperator = function (operator, translate, nestFirst, nestSecond) {
    return (variables) => {
        var first = translate(variables.get('a'));
        var second = translate(variables.get('b'));

        first = nestFirst ? '(' + first + ')' : first;
        second = nestSecond ? '(' + second + ')' : second;

        return first + ' ' + operator + ' ' + second;
    };
};
