
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
var should = require('should');
var ast = require('../lib/ast-builder');
var importer = require('../lib/definition-importer');
var pts = require('../lib/parse-tree-serializer');

describe('definition-importer', function () {
    it('should not import anything given no import statements', function () {
        var original = ast([]);
        var imported = importer.import(original, function (moduleName) {
            throw new Error("Tried to import " + moduleName);
        });

        ast.count(imported).should.equal(0);
    });

    it('should import an empty module', function () {
        var original = ast([['import', 'module']]);
        var imported = importer.import(original, function (moduleName) {
            return ast([]);
        });

        ast.count(imported).should.equal(0);
    });

    it('should define an exported symbol of an imported module in the provided expression', function () {
        var original = ast([['import', 'module-name']]);
        var imported = importer.import(original, function (moduleName) {
            return ast([['export', 'abc', '123']]);
        });

        ast.value(ast.expression(ast.expression(imported, 0), 0)).should.equal('define-from-import');
        ast.value(ast.expression(ast.expression(imported, 0), 1)).should.equal('abc');
        ast.value(ast.expression(ast.expression(imported, 0), 2)).should.equal('123');
    });

    it('should only import a module once', function () {
        var original = ast([['import', 'module-name'], ['import', 'import-again']]);
        var imported = importer.import(original, function (moduleName) {
            if (moduleName === 'import-again') {
                return ast([['import', 'module-name']]);
            } else {
                return ast([['export', 'abc', '123']]);
            }
        });

        ast.count(imported).should.equal(1);
    });

    it('should define all exported symbols of an imported module in the provided expression', function () {
        var original = ast([['import', 'module-name']]);
        var imported = importer.import(original, function (moduleName) {
            return ast([
                ['export', 'efg', '456'],
                ['export', 'abc', '123']
            ]);
        });

        ast.value(ast.expression(ast.expression(imported, 0), 0)).should.equal('define-from-import');
        ast.value(ast.expression(ast.expression(imported, 0), 1)).should.equal('efg');
        ast.value(ast.expression(ast.expression(imported, 0), 2)).should.equal('456');

        ast.value(ast.expression(ast.expression(imported, 1), 0)).should.equal('define-from-import');
        ast.value(ast.expression(ast.expression(imported, 1), 1)).should.equal('abc');
        ast.value(ast.expression(ast.expression(imported, 1), 2)).should.equal('123');
    });

    it('should import all modules specified by import statements', function () {
        var original = ast([
            ['import', 'module-name'],
            ['import', 'module2'],
        ]);

        var imported = importer.import(original, function (moduleName) {
            if (moduleName === 'module-name') {
                return ast([
                    ['export', 'efg', '456']
                ]);
            } else if (moduleName === 'module2') {
                return ast([
                    ['export', 'abc', '123']
                ]);
            }
        });

        ast.value(ast.expression(ast.expression(imported, 0), 0)).should.equal('define-from-import');
        ast.value(ast.expression(ast.expression(imported, 0), 1)).should.equal('efg');
        ast.value(ast.expression(ast.expression(imported, 0), 2)).should.equal('456');

        ast.value(ast.expression(ast.expression(imported, 1), 0)).should.equal('define-from-import');
        ast.value(ast.expression(ast.expression(imported, 1), 1)).should.equal('abc');
        ast.value(ast.expression(ast.expression(imported, 1), 2)).should.equal('123');
    });

    it('should preserve statements in the original ast', function () {
        var original = ast([
            ['import', 'module-name'],
            ['export', 'efg', '456']
        ]);
        var imported = importer.import(original, function (moduleName) {
            return ast([['export', 'abc', '123']]);
        });

        ast.value(ast.expression(ast.expression(imported, 0), 0)).should.equal('define-from-import');
        ast.value(ast.expression(ast.expression(imported, 0), 1)).should.equal('abc');
        ast.value(ast.expression(ast.expression(imported, 0), 2)).should.equal('123');

        ast.value(ast.expression(ast.expression(imported, 1), 0)).should.equal('export');
        ast.value(ast.expression(ast.expression(imported, 1), 1)).should.equal('efg');
        ast.value(ast.expression(ast.expression(imported, 1), 2)).should.equal('456');
    });

    it('should import definitions recursively', function () {
        var original = ast([
            ['import', 'module-name'],
            ['export', 'efg', '456']
        ]);
        var imported = importer.import(original, function (moduleName) {
            if (moduleName === 'module-name') {
                return ast([['import', 'module2']]);
            } else if (moduleName === 'module2') {
                return ast([['export', 'abc', '123']]);
            }
        });

        ast.value(ast.expression(ast.expression(imported, 0), 0)).should.equal('define-from-import');
        ast.value(ast.expression(ast.expression(imported, 0), 1)).should.equal('abc');
        ast.value(ast.expression(ast.expression(imported, 0), 2)).should.equal('123');

        ast.value(ast.expression(ast.expression(imported, 1), 0)).should.equal('export');
        ast.value(ast.expression(ast.expression(imported, 1), 1)).should.equal('efg');
        ast.value(ast.expression(ast.expression(imported, 1), 2)).should.equal('456');
    });

    it('should import definitions with the specific module name', function () {
        var original = ast([
            ['import', 'module-name'],
            ['import', 'module2'],
        ]);
        var imported = importer.import(original, function (moduleName) {
            if (moduleName === 'module-name') {
                return ast([
                    ['export', 'efg', '456'],
                    ['export', 'cde', '762']
                ]);
            } else if (moduleName === 'module2') {
                return ast([
                    ['export', 'abc', '123']
                ]);
            }
        });

        ast.value(ast.expression(ast.expression(imported, 0), 3)).should.equal('module-name');
        ast.value(ast.expression(ast.expression(imported, 1), 3)).should.equal('module-name');

        ast.value(ast.expression(ast.expression(imported, 2), 3)).should.equal('module2');
    });

    it('should prepend imported symbols with the specified name given as a second argument followed by a colon', function () {
        var original = ast([['import', 'module-name', 'some-name']]);
        var imported = importer.import(original, function (moduleName) {
            return ast([['export', 'abc', '123']]);
        });

        ast.value(ast.expression(ast.expression(imported, 0), 0)).should.equal('define-from-import');
        ast.value(ast.expression(ast.expression(imported, 0), 1)).should.equal('some-name:abc');
        ast.value(ast.expression(ast.expression(imported, 0), 2)).should.equal('123');
    });

    it('should prepend imported local symbols with the module path followed by an underscore', function () {
        var original = ast([['import', 'module-name']]);
        var imported = importer.import(original, function (moduleName) {
            return ast([['define', 'abc', '123']]);
        });

        ast.value(ast.expression(ast.expression(imported, 0), 0)).should.equal('define');
        ast.value(ast.expression(ast.expression(imported, 0), 1)).should.equal('module-name_abc');
        ast.value(ast.expression(ast.expression(imported, 0), 2)).should.equal('123');
    });

    it('should handle empty argument lists', function () {
        var original = ast([['import', 'module-name']]);
        var imported = importer.import(original, function (moduleName) {
            return ast([['define', 'abc', ['lambda', [], '1']]]);
        });

        ast.value(ast.expression(ast.expression(imported, 0), 0)).should.equal('define');
        ast.value(ast.expression(ast.expression(imported, 0), 1)).should.equal('module-name_abc');
    });
});
