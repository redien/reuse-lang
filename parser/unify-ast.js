
var Immutable = require('immutable');
var ast = require('./ast');

var NOT_UNIFIED = false;

var throwOverwriteError = (prev, next) => { throw new Error(next + ' overwrites ' + prev) };

var unifyList = function (first, second) {
    var substitutions = Immutable.Map();
    for (var index = 0; index < ast.listSize(first); index++) {
        var firstChild = ast.listChild(first, index);
        var secondChild = ast.listChild(second, index);

        var unified = unifyAst(firstChild, secondChild);
        if (unified === NOT_UNIFIED) {
            return NOT_UNIFIED;
        } else {
            substitutions = substitutions.mergeWith(throwOverwriteError, unified);
        }
    }

    return substitutions;
};

var kindOf = function (expression) {
    if (ast.isAtom(expression)) {
        return 'atom';
    } else {
        return 'list';
    }
};

var variableKindUnifies = function (variable, expression) {
    return variable.kind === undefined || variable.kind === kindOf(expression);
};

var unifyAst = function (first, second) {
    if (ast.equal(first, second)) {
        return Immutable.Map();

    } else if (first.isVariable && !second.isVariable && variableKindUnifies(first, second)) {
        return Immutable.Map.of(first.name, second);

    } else if (second.isVariable && !first.isVariable && variableKindUnifies(second, first)) {
        return Immutable.Map.of(second.name, first);

    } else if (ast.isList(first) && ast.isList(second) && ast.listSize(first) === ast.listSize(second)) {
        return unifyList(first, second);

    } else {
        return NOT_UNIFIED;
    }
};

unifyAst.variable = function (name, kind) {
    return {
        isVariable: true,
        name: name,
        kind: kind
    };
};

unifyAst.NOT_UNIFIED = NOT_UNIFIED;

module.exports = unifyAst;
