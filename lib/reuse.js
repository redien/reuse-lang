
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

var parser = require('../lib/parser');
var translator = require('../lib/javascript-translator/translator');
var importer = require('../lib/definition-importer');

exports.moduleProvider = function (moduleName) {
    return fs.readFileSync(__dirname + '/../' + moduleName).toString();
};

exports.translate = function (program, moduleProvider) {
    var ast = parser.parse(program);
    if (parser.isError(ast)) {
        return {
            error: parser.errorType(ast),
            line: 0,
            column: 0
        };
    }

    var imported = importer.import(parser.value(ast), function (moduleName) {
        return parser.value(parser.parse(moduleProvider(moduleName)));
    });

    var output = translator.translate(imported);
    if (translator.isError(output)) {
        return {
            error: translator.errorType(output),
            line: translator.errorLine(output),
            column: translator.errorColumn(output)
        };
    }

    return {
        value: translator.value(output)
    };
};
