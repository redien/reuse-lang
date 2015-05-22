
var parseAst = function (expression) {
    if (Array.isArray(expression)) {
        return parseArray(expression);
    } else {
        return parseAtom(expression);
    }
};

var parseArray = function (expression) {
    var elements = [];

    var index;
    for (index = 0; index < expression.length; ++index) {
        var element = expression[index];
        elements.push(parseAst(element));
    }

    return {
        kind: 'list',
        elements: elements
    };
};

var parseAtom = function (expression) {
    return {
        kind: 'atom',
        value: expression
    };
};

module.exports = parseAst;
