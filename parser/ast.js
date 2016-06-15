
var Immutable = require('immutable');

var ast = module.exports;

ast.equal = function (a, b) {
    if (ast.isList(a) && ast.isList(b)) {
        return Immutable.is(a, b);
    } else if (a === b) {
        return true;
    } else {
        return false;
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
    return Immutable.List.of.apply(Immutable.List, arguments);
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
