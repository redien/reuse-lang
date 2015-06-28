
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

var translateParameters = function (parameters) {
    var translatedString = '';
    parameters.forEach(function (parameter) {
        translatedString += parameter.value;
    });
    return translatedString;
};

exports.translate = function (ast) {
    var translatedString =
        'module.exports.' + ast.elements[1].value +
        ' = function (' + translateParameters(ast.elements[2].elements[1].elements) + ') { ' +
            'return ' + ast.elements[2].elements[2].value +
        '; }';

    return {error: null, value: translatedString};
};