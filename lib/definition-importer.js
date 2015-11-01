
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
    var statementIndex;
    var statementCount = ast.count(module);
    for (statementIndex = 0; statementIndex < statementCount; ++statementIndex) {
        var statement = ast.expression(module, statementIndex);

        if (ast.value(ast.expression(statement, 0)) === 'export') {
            var define = ast([]);
            ast.push(define, ast('define'));
            ast.push(define, ast.expression(statement, 1));
            ast.push(define, ast.expression(statement, 2));
            ast.push(imported, define);
        } else if (ast.value(ast.expression(statement, 0)) === 'import') {
            recur(imported, ast.value(ast.expression(statement, 1)), moduleProvider);
        }
    }
};

exports.import = function (original, moduleProvider) {
    var imported = ast([]);

    var statementIndex;
    var statementCount = ast.count(original);
    for (statementIndex = 0; statementIndex < statementCount; ++statementIndex) {
        var statement = ast.expression(original, statementIndex);

        if (ast.value(ast.expression(statement, 0)) === 'import') {
            importModule(imported, ast.value(ast.expression(statement, 1)), moduleProvider);
        } else {
            ast.push(imported, statement);
        }
    }

    return imported;
};
