
var Immutable = require('immutable');
var type = module.exports;

type.primitiveType = function (name) {
    return {
        name: name
    };
};

type.functionType = function (argumentTypes, expressionType) {
    return {
        name: 'function',
        argumentTypes: argumentTypes,
        expressionType: expressionType
    };
};

type.constant = function () {
    return {
        kind: 'constant',
        type: type.primitiveType('int')
    };
};

type.symbol = function (type) {
    return {
        kind: 'symbol',
        type: type
    };
};

type.application = function (type, expressions) {
    return {
        kind: 'application',
        type: type,
        expressions: expressions
    }
};

type.lambda = function (argumentTypes, expressionType, expression) {
    return {
        kind: 'lambda',
        type: type.functionType(argumentTypes, expressionType),
        expressions: Immutable.List.of(expression)
    };
};

type.expressions = function (node) {
    return node.expressions;
}

type.kind = function (node) {
    return node.kind;
};

type.type = function (node) {
    return node.type;
};

type.name = function (type) {
    return type.name;
};

type.expressionType = function (type) {
    return type.expressionType;
};

var typeToString = function (type) {
    if (type.name === 'function') {
        return '(function (' + type.argumentTypes.map(typeToString).join(' ') + ') ' + typeToString(type.expressionType) + ')';

    } else {
        return type.name;
    }
};

var nodeToString = function (node) {
    if (node.kind === 'lambda') {
        return '(lambda ' + typeToString(node.type) + ' () ' + nodeToString(node.expressions.get(0)) + ')';

    } else if (node.kind === 'application') {
        return '(application ' + typeToString(node.type) + ' (' + node.expressions.map(nodeToString).join(' ') + '))';

    } else if (node.kind === 'symbol') {
        return '(symbol ' + typeToString(node.type) + ')';

    } else {
        return '(constant ' + typeToString(node.type) + ')';
    }
};

type.stringify = function (node) {
    return nodeToString(node);
};
