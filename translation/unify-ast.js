
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

var unifyAst = function (first, second) {
    if (areEqual(first, second)) {
        return Immutable.Map();

    } else if (first.isVariable && !second.isVariable) {
        return Immutable.Map.of(first.name, second);

    } else if (second.isVariable && !first.isVariable) {
        return Immutable.Map.of(second.name, first);

    } else if (Immutable.List.isList(first) && Immutable.List.isList(second) && first.size === second.size) {
        return unifyList(first, second);

    } else {
        return false;
    }
};

unifyAst.variable = function (name) {
    return {
        isVariable: true,
        name: name
    };
}

module.exports = unifyAst;
