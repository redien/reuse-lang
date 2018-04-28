var Immutable = require('immutable');
var assert = require('assert');
var util = require('util');

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
    assert(typeof value === 'string', 'Expected string');
    return Immutable.Map.of('type', 'atom', 'value', value);
};

ast.isAtom = function(atom) {
    return Immutable.Map.isMap(atom) && atom.get('type') === 'atom';
};

ast.value = function(atom) {
    assert(ast.isAtom(atom), 'Expected atom');
    return atom.get('value');
};

ast.list = function() {
    return Immutable.Map.of('type', 'list', 'value', Immutable.List(arguments));
};

ast.listFrom = function(array) {
    return Immutable.Map.of('type', 'list', 'value', Immutable.List(array));
};

ast.isList = function(list) {
    return Immutable.Map.isMap(list) && list.get('type') === 'list';
};

ast.isExpression = function(expression) {
    return ast.isAtom(expression) || ast.isList(expression);
};

ast.push = function(list, value) {
    assert(ast.isList(list), 'Expected list');
    return list.set('value', list.get('value').push(value));
};

ast.concat = function(list, otherList) {
    assert(ast.isList(list), 'Expected list');
    assert(ast.isList(otherList), 'Expected list');
    return list.set('value', list.get('value').concat(otherList.get('value')));
};

ast.setIn = function(list, keyPath, value) {
    assert(ast.isList(list), 'Expected list');
    assert(ast.isExpression(value), 'Expected an expression');
    return list.set('value', list.get('value').setIn(keyPath, value));
};

ast.updateIn = function(list, keyPath, updater) {
    assert(ast.isList(list), 'Expected list');
    return list.set('value', list.get('value').updateIn(keyPath, updater));
};

ast.insert = function(list, index, value) {
    assert(ast.isList(list), 'Expected list');
    assert(ast.isExpression(value), 'Expected an expression');
    return list.set('value', list.get('value').insert(index, value));
};

ast.slice = function(list, start, end) {
    assert(ast.isList(list), 'Expected list');
    return list.set('value', list.get('value').slice(start, end));
};

ast.reverse = function(list) {
    assert(ast.isList(list), 'Expected list');
    return list.set('value', list.get('value').reverse());
};

ast.size = function(list) {
    assert(ast.isList(list), 'Expected list');
    return list.get('value').size;
};

ast.child = function(list, index) {
    assert(ast.isList(list), 'Expected list');
    assert(index < ast.size(list) && index >= 0, 'Index out of bounds');
    return list.get('value').get(index);
};

ast.flatMap = function(list, f) {
    assert(ast.isList(list), 'Expected list');
    const mapped = ast.map(list, f);
    return ast.reduce(mapped, ast.concat, ast.list());
};

ast.map = function(list, f) {
    assert(ast.isList(list), 'Expected list');
    return list.set('value', list.get('value').map(f));
};

ast.reduce = function(list, f, initialValue) {
    assert(ast.isList(list), 'Expected list');
    return list.get('value').reduce(f, initialValue);
};

ast.toArray = function(list) {
    assert(ast.isList(list), 'Expected list');
    return ast.reduce(list, (newList, item) => [...newList, item], []);
};

ast.filter = function(list, f) {
    assert(ast.isList(list), 'Expected list');
    return list.set('value', list.get('value').filter(f));
};

ast.join = function(list, separator) {
    assert(ast.isList(list), 'Expected list');
    return list.get('value').join(separator);
};

ast.some = function(list, f) {
    assert(ast.isList(list), 'Expected list');
    return list.get('value').some(f);
};

ast.contains = function(list, v) {
    assert(ast.isList(list), 'Expected list');
    return list.get('value').some(function(o) {
        return o === v;
    });
};

ast.every = function(list, f) {
    assert(ast.isList(list), 'Expected list');
    return list.get('value').every(f);
};

ast.toString = function toString(expression) {
    if (ast.isList(expression)) {
        return '(' + ast.join(ast.map(expression, toString), ' ') + ')';
    } else if (ast.isAtom(expression)) {
        return ast.value(expression);
    } else {
        throw new Error(`Invalid expression ${util.inspect(expression)}`);
    }
};

ast.getMeta = function(ast, key) {
    return ast.get(key);
};

ast.setMeta = function(ast, key, value) {
    return ast.set(key, value);
};
