
// reuse-lang - a pure functional lisp-like language for writing
// reusable algorithms in an extremely portable way.
//
// Written in 2015 by Jesper Oskarsson jesosk@gmail.com
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

var ast = require('../lib/ast-builder');

var replaceSymbolInExpression = function replaceSymbolInExpression (from, to, expression) {
    if (expression.kind === 'atom') {
        if (expression.value === from) {
            return ast(to);
        } else {
            return expression;
        }
    } else {
        var newExpression = ast([]);
        expression.elements.forEach(function (element) {
            newExpression.elements.push(replaceSymbolInExpression(from, to, element));
        })
        return newExpression;
    }
};

var isLambda = function (expression) {
    return  expression.kind === 'list' &&
            expression.elements.length >= 3 &&
            expression.elements[0].kind === 'atom' &&
            expression.elements[0].value === 'lambda' &&
            expression.elements[1].kind == 'list';
};

var parameterIsDefined = function (parameter, definedSymbols) {
    return parameter.kind === 'atom' &&
           definedSymbols.indexOf(parameter.value) !== -1;
};

var newUndefinedSymbol = function (oldSymbol, definedSymbols) {
    var postfix = oldSymbol.match(/\d+$/);
    var ordinal = 1;
    var prefix;
    if (!postfix) {
        prefix = oldSymbol;
    } else {
        ordinal = parseInt(postfix[0]);
        prefix = oldSymbol.substr(0, oldSymbol.length - postfix[0].length);
    }

    var newSymbol;
    do {
        ordinal += 1;
        newSymbol = prefix + ordinal;
    } while (definedSymbols.indexOf(newSymbol) !== -1);

    return newSymbol;
};



exports.renameShadowingSymbols = function renameShadowingSymbols (expression, definedSymbols) {
    if (isLambda(expression)) {
        var parameters = expression.elements[1].elements;
        var newExpression = expression.elements[2];
        var newParameters = ast([]);
        var newDefinedSymbols = [];

        parameters.forEach(function (parameter) {
            if (parameterIsDefined(parameter, definedSymbols)) {
                var symbol = parameter.value;
                var newSymbol = newUndefinedSymbol(symbol, definedSymbols);

                newExpression = replaceSymbolInExpression(symbol, newSymbol, newExpression);

                newDefinedSymbols.push(newSymbol);
                newParameters.elements.push(ast(newSymbol));
            } else {
                newParameters.elements.push(parameter);
            }
        });

        newDefinedSymbols = newDefinedSymbols.concat(definedSymbols);
        var newLambda = ast(['lambda']);
        newLambda.elements.push(newParameters);
        newLambda.elements.push(renameShadowingSymbols(newExpression, newDefinedSymbols));
        return newLambda;

    } else {
        if (expression.kind === 'atom') {
            return expression;
        } else {
            var newExpression = ast([]);
            expression.elements.forEach(function (element) {
                newExpression.elements.push(renameShadowingSymbols(element, definedSymbols));
            });
            return newExpression;
        }
    }
};
