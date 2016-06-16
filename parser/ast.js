
var Immutable = require('immutable');

var ast = module.exports;

ast.equal = function (a, b) {
    if (ast.isList(a) && ast.isList(b)) {
        return Immutable.is(a, b);
    } else {
        return a === b;
    }
};

ast.atom = function (value) {
    return value;
};

ast.isAtom = function (atom) {
    return typeof atom === 'string';
};

ast.atomValue = function (atom) {
    return atom;
};

ast.list = function () {
    return Immutable.List(arguments);
};

ast.isList = function (list) {
    return list.constructor === Immutable.List;
};

ast.listPush = function (list, value) {
    return list.push(value);
};

ast.listSize = function (list) {
    return list.size;
};

ast.listChild = function (list, index) {
    return list.get(index);
};