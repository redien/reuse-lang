
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

describe('definition-importer', function () {
    it('should define an exported symbol of an imported module in the provided expression', function () {
        var original = ast([['import', 'module-name']]);
        var imported = importer.import(original, function (moduleName) {
            return ast([['export', 'abc', '123']]);
        });

        imported.elements[0].elements[0].value.should.equal('define');
        imported.elements[0].elements[1].value.should.equal('abc');
        imported.elements[0].elements[2].value.should.equal('123');
    });

    it('should define all exported symbols of an imported module in the provided expression', function () {
        var original = ast([['import', 'module-name']]);
        var imported = importer.import(original, function (moduleName) {
            return ast([
                ['export', 'efg', '456'],
                ['export', 'abc', '123']
            ]);
        });

        imported.elements[0].elements[0].value.should.equal('define');
        imported.elements[0].elements[1].value.should.equal('efg');
        imported.elements[0].elements[2].value.should.equal('456');

        imported.elements[1].elements[0].value.should.equal('define');
        imported.elements[1].elements[1].value.should.equal('abc');
        imported.elements[1].elements[2].value.should.equal('123');
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

        imported.elements[0].elements[0].value.should.equal('define');
        imported.elements[0].elements[1].value.should.equal('efg');
        imported.elements[0].elements[2].value.should.equal('456');

        imported.elements[1].elements[0].value.should.equal('define');
        imported.elements[1].elements[1].value.should.equal('abc');
        imported.elements[1].elements[2].value.should.equal('123');
    });

    it('should preserve statements in the original ast', function () {
        var original = ast([
            ['import', 'module-name'],
            ['export', 'efg', '456']
        ]);
        var imported = importer.import(original, function (moduleName) {
            return ast([['export', 'abc', '123']]);
        });

        imported.elements[0].elements[0].value.should.equal('define');
        imported.elements[0].elements[1].value.should.equal('abc');
        imported.elements[0].elements[2].value.should.equal('123');

        imported.elements[1].elements[0].value.should.equal('export');
        imported.elements[1].elements[1].value.should.equal('efg');
        imported.elements[1].elements[2].value.should.equal('456');
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

        imported.elements[0].elements[0].value.should.equal('define');
        imported.elements[0].elements[1].value.should.equal('abc');
        imported.elements[0].elements[2].value.should.equal('123');

        imported.elements[1].elements[0].value.should.equal('export');
        imported.elements[1].elements[1].value.should.equal('efg');
        imported.elements[1].elements[2].value.should.equal('456');
    });
});
