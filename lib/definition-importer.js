
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

var ast = require('./ast-builder');

var importModule = function recur (imported, moduleName, moduleProvider) {
    var module = moduleProvider(moduleName);
    var statements = module.elements;
    var statementIndex;
    for (statementIndex = 0; statementIndex < statements.length; ++statementIndex) {
        var statement = statements[statementIndex];

        if (statement.elements[0].value === 'export') {
            var define = ast([]);
            define.elements.push(ast('define'));
            define.elements.push(statement.elements[1]);
            define.elements.push(statement.elements[2]);
            imported.elements.push(define);
        } else if (statement.elements[0].value === 'import') {
            recur(imported, statement.elements[1].value, moduleProvider);
        }
    }
};

exports.import = function (original, moduleProvider) {
    var imported = ast([]);

    var statements = original.elements;
    var statementIndex;
    for (statementIndex = 0; statementIndex < statements.length; ++statementIndex) {
        var statement = statements[statementIndex];

        if (statement.elements[0].value === 'import') {
            importModule(imported, statement.elements[1].value, moduleProvider);
        } else {
            imported.elements.push(statement);
        }
    }

    return imported;
};
