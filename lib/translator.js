
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

var standardLibrary = fs.readFileSync(__dirname + '/../lib/standard-library.js').toString();

var translateParameters = function (parameters) {
    var translatedString = '';
    parameters.forEach(function (parameter) {
        translatedString += parameter.value;
    });
    return translatedString;
};

var translateFunctionApplication = function (ast) {
    var result = ast.elements[0].value + '(';

    var argumentIndex;
    for (argumentIndex = 1; argumentIndex < ast.elements.length; ++argumentIndex) {
        var argument = ast.elements[argumentIndex];

        if (argumentIndex !== 1) {
            result += ', ';
        }

        result += argument.value;
    }

    return result + ')';
};

exports.translate = function (ast) {
    var expression;
    if (ast.elements[2].elements[2].kind === 'atom') {
        expression = ast.elements[2].elements[2].value;
    } else {
        expression = translateFunctionApplication(ast.elements[2].elements[2]);
    }

    var translatedString =
        standardLibrary +
        'module.exports.' + ast.elements[1].value +
        ' = function (' + translateParameters(ast.elements[2].elements[1].elements) + ') { ' +
            'return ' + expression +
        '; }';

    return {error: null, value: translatedString};
};
