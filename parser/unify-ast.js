
var Immutable = require('immutable');
var ast = require('./ast');

var NOT_UNIFIED = 'not unified';

module.exports = function (first, second, occursCheck) {
    var state = {
        equations: Immutable.List.of({left: first, right: second}),
        substitutions: Immutable.List()
    };

    while (state.equations.size > 0) {
        state = unificationStep(state, occursCheck);
        if (state === NOT_UNIFIED) { return NOT_UNIFIED; }
    }

    return convertEquationsToMap(state.substitutions);
};

var unificationStep = function (state, occursCheck) {
    for (var index = 0; index < state.equations.size; ++index) {
        var equation = state.equations.get(index);

        if      (canDelete(equation))       { return _delete(state, index); }
        else if (canDecompose(equation))    { return decompose(state, index); }
        else if (canEliminate(equation,
                              occursCheck)) { return eliminate(state, index); }
        else if (canSwap(equation))         { return swap(state, index); }
        else                                { return NOT_UNIFIED; }
    }
};


var canDelete = function (equation) {
    return areEqual(equation.left, equation.right);
};

var _delete = function (state, index) {
    return stateSet(state, state.equations.delete(index));
};

var canDecompose = function (equation) {
    return areLists(equation.left, equation.right) &&
           ast.size(equation.left) === ast.size(equation.right);
};

var decompose = function (state, index) {
    var equation = state.equations.get(index);
    var equations = state.equations.delete(index);
    equations = equations.concat(decomposeLists(equation.left, equation.right))
    return stateSet(state, equations);
};

var canEliminate = function (equation, occursCheck) {
    return equation.left.isVariable &&
           variableTypeMatches(equation.left, equation.right) &&
           (occursCheck === false || !occursIn(equation.left, equation.right));
};

var variableTypeMatches = function (variable, expression) {
    return variable.kind === undefined || // Any type matches
           variable.kind === 'atom' && ast.isAtom(expression) ||
           variable.kind === 'list' && ast.isList(expression);
};

var occursIn = function (variable, expression) {
    if      (areEqual(variable, expression))      { return true; }
    else if (occursInList(variable, expression))  { return true; }
    else                                          { return false; }
};

var eliminate = function (state, index) {
    var equation      = state.equations.get(index);
    var equations     = eliminateInEquations(equation.left, equation.right, state.equations.delete(index));
    var substitutions = eliminateInEquations(equation.left, equation.right, state.substitutions).push(equation);
    return stateSet(state, equations, substitutions);
};

var canSwap = function (equation) {
    return equation.right.isVariable;
};

var swap = function (state, index) {
    var equation = state.equations.get(index);
    return stateSet(state, state.equations.set(index, {
        left: equation.right,
        right: equation.left
    }));
};


var atomsAreEqual = function (first, second) {
    return ast.value(first) === ast.value(second);
};

var listsAreEqual = function (first, second) {
    return (ast.size(first) === ast.size(second)) &&
           ast.every(first, function (item, index) { return areEqual(item, ast.child(second, index)); });
};

var variablesAreEqual = function (first, second) {
    return first.name === second.name;
};

var areAtoms = function (first, second) {
    return ast.isAtom(first) && ast.isAtom(second);
};

var areLists = function (first, second) {
    return ast.isList(first) && ast.isList(second);
};

var areVariables = function (first, second) {
    return first.isVariable && second.isVariable;
};

var areEqual = function (first, second) {
    return (areAtoms(first, second) && atomsAreEqual(first, second)) ||
           (areLists(first, second) && listsAreEqual(first, second)) ||
           (areVariables(first, second) && variablesAreEqual(first, second));
};


var occursInList = function (variable, list) {
    var occursInExpression = function (expression) {
        return occursIn(variable, expression);
    };

    return ast.isList(list) && ast.some(list, occursInExpression);
};

var decomposeLists = function (first, second) {
    var list = Immutable.List();
    for (var index = 0; index < ast.size(first); ++index) {
        list = list.push({
            left: ast.child(first, index),
            right: ast.child(second, index)
        });
    }
    return list;
};

var stateSet = function (state, equations, substitutions) {
    return {
        equations: equations,
        substitutions: substitutions || state.substitutions
    };
};

var eliminateInList = function (variable, value, list) {
    return ast.map(list, function (expression) {
        return eliminateInExpression(variable, value, expression);
    });
};

var eliminateInExpression = function (variable, value, expression) {
    if      (ast.isList(expression))         { return eliminateInList(variable, value, expression); }
    else if (areEqual(variable, expression)) { return value; }
    else                                     { return expression; }
};

var eliminateInEquations = function (variable, value, equations) {
    return equations.map(function (equation) {
        return {
            left:  eliminateInExpression(variable, value, equation.left),
            right: eliminateInExpression(variable, value, equation.right)
        };
    });
};

var convertEquationsToMap = function (equations) {
    return equations.reduce(function (map, equation) {
        return map.set(equation.left.name, equation.right);
    }, Immutable.Map());
};


module.exports.variable = function (name, kind) {
    return {
        isVariable: true,
        name: name,
        kind: kind
    };
};

module.exports.NOT_UNIFIED = NOT_UNIFIED;
