
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

var intrinsics = fs.readFileSync(__dirname + '/intrinsics.js').toString();

var translateParameters = function (parameters) {
    var translatedString = '';

    var parameterIndex;
    for (parameterIndex = 0; parameterIndex < parameters.length; ++parameterIndex) {
        var parameter = parameters[parameterIndex];

        if (parameterIndex !== 0) {
            translatedString += ', ';
        }

        translatedString += parameter.value;
    }

    return translatedString;
};

var translateFunctionApplication = function (ast) {
    var result = translateExpression(ast.elements[0]) + '(';

    var argumentIndex;
    for (argumentIndex = 1; argumentIndex < ast.elements.length; ++argumentIndex) {
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

var translateExpression = function (ast) {
    if (ast.kind === 'atom') {
        return ast.value;
    } else {
        if (ast.elements[0].value === 'lambda') {
            return translateLambda(ast);
        } else {
            return translateFunctionApplication(ast);
        }
    }
};

exports.translate = function (ast) {
    var translatedString =
        intrinsics +
        'module.exports.' + ast.elements[1].value +
        ' = ' + translateLambda(ast.elements[2]) + ';';

    return {error: null, value: translatedString};
};
