
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
    var result = translateExpression(ast.elements[0]) + '(';

    var argumentIndex;
    for (argumentIndex = 1; argumentIndex < ast.elements.length; ++argumentIndex) {
        var argument = ast.elements[argumentIndex];

        if (argumentIndex !== 1) {
            result += ', ';
        }

        result += translateExpression(argument);
    }

    return result + ')';
};

var translateLambda = function (ast) {
    return '(function (' + translateParameters(ast.elements[1].elements) + ') { ' +
        'return ' + translateExpression(ast.elements[2]) +
    '; })';
};

var translateDefine = function (ast) {
    return '(function (' + translateParameters(ast.elements[1].elements, 0, 2) + ') { return ' + translateExpression(ast.elements[2]) + '; })(' + translateParameters(ast.elements[1].elements, 1, 2) + ')';
};

var translateExpression = function (ast) {
    if (ast.kind === 'atom') {
        if (symbolIsNumber(ast)) {
            return ast.value;
        } else {
            return symbolNameEncoder.encode(ast.value);
        }
    } else {
        if (ast.elements[0].value === 'lambda') {
            return translateLambda(ast);
        } else if (ast.elements[0].value === 'define') {
            return translateDefine(ast);
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

exports.translate = function (ast) {
    if (!nameCanBeExported(ast.elements[1].value)) {
        var error = new Error("exported_symbol_contains_invalid_character");
        error.line = ast.elements[1].line;
        error.column = ast.elements[1].column + indexOfFirstInvalidCharacter(ast.elements[1].value);

        return {
            error: error
        };
    }

    var translatedString =
        intrinsics +
        'module.exports.' + ast.elements[1].value +
        ' = ' + translateExpression(ast.elements[2]) + ';';

    return {error: null, value: translatedString};
};
