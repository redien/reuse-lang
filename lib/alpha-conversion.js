
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

var isNumber = function (character) {
    return character === '0' ||
            character === '1' ||
            character === '2' ||
            character === '3' ||
            character === '4' ||
            character === '5' ||
            character === '6' ||
            character === '7' ||
            character === '8' ||
            character === '9';
}

var renameSymbol = function (symbolToRename, definedSymbols) {
    var index = 2;

    var lastCharacter = symbolToRename.substr(-1);
    if (isNumber(lastCharacter)) {
        index = parseInt(lastCharacter, 10) + 1;
        symbolToRename = symbolToRename.substr(0, -1);
    }

    var newSymbol;
    do  {
        newSymbol = symbolToRename + index;
        index += 1;
    } while (definedSymbols.indexOf(newSymbol) !== -1);

    return newSymbol;
};

exports.renameShadowingSymbols = function renameShadowingSymbols (expression, definedSymbols) {
    if (expression.kind === 'atom') {
        if (definedSymbols.indexOf(expression.value) !== -1) {
            return ast(renameSymbol(expression.value, definedSymbols));
        } else {
            return expression;
        }

    } else if (expression.elements.length === 0) {
        return expression;

    } else if (expression.elements[0].value === 'lambda') {
        var parameterIndex;
        var newParameters = ast([]);

        for (parameterIndex = 0; parameterIndex < expression.elements[1].elements.length; ++parameterIndex) {
            var parameter = expression.elements[1].elements[parameterIndex];
            newParameters.elements.push(renameShadowingSymbols(parameter, definedSymbols));
        }

        var newAst = ast(['lambda']);
        newAst.elements[1] = newParameters;
        newAst.elements[2] = renameShadowingSymbols(expression.elements[2], definedSymbols);
        return newAst;

    } else {
        var newAst = ast([]);

        var elementIndex;
        for (elementIndex = 0; elementIndex < expression.elements.length; ++elementIndex) {
            var element = expression.elements[elementIndex];
            newAst.elements.push(renameShadowingSymbols(element, definedSymbols));
        }

        return newAst;
    }
};
