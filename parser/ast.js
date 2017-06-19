var Immutable = require('immutable');

var ast = module.exports;

ast.equal = function equal(a, b) {
    if (ast.isList(a) && ast.isList(b)) {
        return ast.every(a, function(item, index) {
            return equal(item, b.child(index));
        });
    } else {
        return a.get('value') === b.get('value');
    }
};

ast.atom = function(value) {
    return Immutable.Map.of('type', 'atom', 'value', value);
};

ast.isAtom = function(atom) {
    return Immutable.Map.isMap(atom) && atom.get('type') === 'atom';
};

ast.value = function(atom) {
    return atom.get('value');
};

ast.list = function() {
    return Immutable.Map.of('type', 'list', 'value', Immutable.List(arguments));
};

ast.isList = function(list) {
    return Immutable.Map.isMap(list) && list.get('type') === 'list';
};

ast.push = function(list, value) {
    return list.set('value', list.get('value').push(value));
};

ast.slice = function(list, start, end) {
    return list.set('value', list.get('value').slice(start, end));
};

ast.size = function(list) {
    return list.get('value').size;
};

ast.child = function(list, index) {
    return list.get('value').get(index);
};

ast.map = function(list, f) {
    return list.set('value', list.get('value').map(f));
};

ast.filter = function(list, f) {
    return list.set('value', list.get('value').filter(f));
};

ast.join = function(list, separator) {
    return list.get('value').join(separator);
};

ast.some = function(list, f) {
    return list.get('value').some(f);
};

ast.contains = function(list, v) {
    return list.get('value').some(function(o) {
        return o === v;
    });
};

ast.every = function(list, f) {
    return list.get('value').every(f);
};

ast.toString = function toString(expression) {
    if (ast.isList(expression)) {
        return '(' + ast.join(ast.map(expression, toString), ' ') + ')';
    } else {
        return ast.value(expression);
    }
};

ast.getMeta = function(ast, key) {
    return ast.get(key);
};

ast.setMeta = function(ast, key, value) {
    return ast.set(key, value);
};
