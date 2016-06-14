
var Immutable = require('immutable');

var areEqual = (first, second) => Immutable.is(first, second) || first === second;

var throwOverwriteError = (prev, next) => { throw new Error(next + ' overwrites ' + prev) };

var unifyList = function (first, second) {
    var substitutions = Immutable.Map();
    for (var index = 0; index < first.size; index++) {
        var firstChild = first.get(index);
        var secondChild = second.get(index);

        var unified = unifyAst(firstChild, secondChild);
        if (unified === false) {
            return false;
        } else {
            substitutions = substitutions.mergeWith(throwOverwriteError, unified);
        }
    }

    return substitutions;
};

var kindOf = function (ast) {
    if (typeof ast === 'string') {
        return 'atom';
    } else {
        return 'list';
    }
};

var variableKindUnifies = function (variable, ast) {
    return variable.kind === undefined || variable.kind === kindOf(ast);
};

var unifyAst = function (first, second) {
    if (areEqual(first, second)) {
        return Immutable.Map();

    } else if (first.isVariable && !second.isVariable && variableKindUnifies(first, second)) {
        return Immutable.Map.of(first.name, second);

    } else if (second.isVariable && !first.isVariable && variableKindUnifies(second, first)) {
        return Immutable.Map.of(second.name, first);

    } else if (Immutable.List.isList(first) && Immutable.List.isList(second) && first.size === second.size) {
        return unifyList(first, second);

    } else {
        return false;
    }
};

unifyAst.variable = function (name, kind) {
    return {
        isVariable: true,
        name: name,
        kind: kind
    };
}

module.exports = unifyAst;
