
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

var fs = require('fs');
var symbolNameEncoder = require(__dirname + '/../symbol-name-encoder');

var intrinsics = fs.readFileSync(__dirname + '/intrinsics.js').toString();

var symbolIsNumber = function (symbol) {
    return symbol.value.match(/^[0-9]/) !== null;
};

var translateParameters = function (parameters, offset, stride) {
    var translatedString = '';

    offset = offset || 0;
    stride = stride || 1;

    var parameterIndex;
    for (parameterIndex = offset; parameterIndex < parameters.length; parameterIndex += stride) {
        var parameter = parameters[parameterIndex];

        if (parameterIndex !== offset) {
            translatedString += ', ';
        }

        if (symbolIsNumber(parameter)) {
            translatedString += parameter.value;
        } else {
            translatedString += symbolNameEncoder.encode(parameter.value);
        }
    }

    return translatedString;
};

var translateFunctionApplication = function (ast) {
    return translateExpression(ast.elements[0]) + '(' + translateFunctionArguments(ast.elements, 1, 1) + ')'
};

var translateFunctionArguments = function (arguments, offset, stride) {
    var result = '';

    var argumentIndex;
    for (argumentIndex = offset; argumentIndex < arguments.length; argumentIndex += stride) {
        var argument = arguments[argumentIndex];

        if (argumentIndex !== offset) {
            result += ', ';
        }

        result += translateExpression(argument);
    }

    return result;
};

var expressionContainsRecur = function expressionContainsRecur(ast) {
    if (ast.kind === 'atom') {
        return false;
    } else {
        if (ast.elements.length > 0 && ast.elements[0].value === 'lambda') {
            return false;
        } else if (ast.elements.length > 0 && ast.elements[0].value === 'recur') {
            return true;
        } else {
            var expressionIndex;
            for (expressionIndex = 0; expressionIndex < ast.elements.length; ++expressionIndex) {
                var expression = ast.elements[expressionIndex];

                if (expressionContainsRecur(expression)) {
                    return true;
                }
            }

            return false;
        }
    }
};

var translateLambda = function (ast) {
    return '(function ' + (expressionContainsRecur(ast.elements[2]) ? 'recur' : '') + '(' + translateParameters(ast.elements[1].elements) + ') { ' +
        'return ' + translateExpression(ast.elements[2]) +
    '; })';
};

var translateDefine = function (ast) {
    return '(function (' + translateParameters(ast.elements[1].elements, 0, 2) + ') { return ' + translateExpression(ast.elements[2]) + '; })(' + translateFunctionArguments(ast.elements[1].elements, 1, 2) + ')';
};

var translateIfStatement = function (ast) {
    return '(' + translateExpression(ast.elements[1]) + ' ? ' + translateExpression(ast.elements[2]) + ' : ' + translateExpression(ast.elements[3]) + ')';
};

var translateExpression = function (ast) {
    if (ast.kind === 'atom') {
        if (symbolIsNumber(ast)) {
            var integer = parseInt(ast.value, 10);
            if (integer > 2147483647) {
                var error = new Error('invalid_integer_constant');
                error.line = ast.line;
                error.column = ast.column;
                throw error;
            }
            return ast.value;
        } else {
            return symbolNameEncoder.encode(ast.value);
        }
    } else {
        if (ast.elements[0].value === 'lambda') {
            return translateLambda(ast);
        } else if (ast.elements[0].value === 'define') {
            return translateDefine(ast);
        } else if (ast.elements[0].value === 'if') {
            return translateIfStatement(ast);
        } else {
            return translateFunctionApplication(ast);
        }
    }
};

var nameCanBeExported = function (name) {
    return name.match(/^[a-zA-Z0-9_]+$/) !== null;
};

var indexOfFirstInvalidCharacter = function (name) {
    return name.match(/[^a-zA-Z0-9_]+/).index;
}

var findErrorFromInvalidExportedSymbols = function (ast) {
    var exportIndex;

    for (exportIndex = 0; exportIndex < ast.elements.length; ++exportIndex) {
        var exportAst = ast.elements[exportIndex];

        if (!nameCanBeExported(exportAst.elements[1].value)) {
            var error = new Error("exported_symbol_contains_invalid_character");
            error.line = exportAst.elements[1].line;
            error.column = exportAst.elements[1].column + indexOfFirstInvalidCharacter(exportAst.elements[1].value);

            return error;
        }
    }
};

exports.translate = function (ast) {
    var error = findErrorFromInvalidExportedSymbols(ast);
    if (error !== undefined) {
        return {
            error: error
        };
    }

    try {
        var translatedString =
            intrinsics;

        var exportIndex;
        for (exportIndex = 0; exportIndex < ast.elements.length; ++exportIndex) {
            var exportAst = ast.elements[exportIndex];
            translatedString +=
                'module.exports.' + exportAst.elements[1].value +
                ' = ' + translateExpression(exportAst.elements[2]) + ';';

            if (exportIndex > 0) {
                translatedString += '\n';
            }
        }

        return {error: null, value: translatedString};

    } catch (error) {
        return {error: error};
    }
};
