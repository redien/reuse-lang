
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

var should = require('should');
var ast = require('../lib/ast-builder');

describe('ast-builder', function () {
    describe('kind', function () {
        it('should return "atom" for an atom', function () {
            ast.kind(ast('abc')).should.equal('atom');
        });

        it('should return "list" for a list', function () {
            ast.kind(ast([])).should.equal('list');
        });
    });

    describe('value', function () {
        it('should return the value of an atom', function () {
            ast.value(ast('abc')).should.equal('abc');
        });
    });

    describe('line', function () {
        it('should return the line of the given atom', function () {
            ast.line(ast.expression(ast.expression(ast([['abc']]), 0), 0)).should.equal(1);
        });
    });

    describe('column', function () {
        it('should return the column of the given atom', function () {
            ast.column(ast.expression(ast.expression(ast([['abc']]), 0), 0)).should.equal(2);
        });
    });

    describe('expression', function () {
        it('should return the first expression of a list given an index of 0', function () {
            ast.value(ast.expression(ast(['abc']), 0)).should.equal('abc');
        });

        it('should return the n-th expression of a list given an index of n - 1', function () {
            var expression = ast(['abc', 'def', 'def']);

            ast.value(ast.expression(expression, 1)).should.equal('def');
        });
    });

    describe('count', function () {
        it('should return 0 given an empty list', function () {
            ast.count(ast([])).should.equal(0);
        });

        it('should return n given a list of n items', function () {
            ast.count(ast(['abc', 'abc', 'abc'])).should.equal(3);
        });
    });

    it('should return an atom given the string "abc"', function () {
        ast.kind(ast('abc')).should.equal('atom');
    });

    it('should return a value "cba" given the string "cba"', function () {
        ast.value(ast('cba')).should.equal('cba');
    });

    it('should return a list given []', function () {
        ast.kind(ast([])).should.equal('list');
    });

    it('should return a list of atom "123" given ["123"]', function () {
        ast.value(ast.expression(ast(["123"]), 0)).should.equal('123');
    });

    it('should return a list of atom "123", "234" and "0" given ["123", "234", "0"]', function () {
        var result = ast(['123', '234', '0']);
        ast.value(ast.expression(result, 0)).should.equal('123');
        ast.value(ast.expression(result, 1)).should.equal('234');
        ast.value(ast.expression(result, 2)).should.equal('0');
    });

    it('should return a list with one list given [[]]', function () {
        ast.kind(ast.expression(ast([[]]), 0)).should.equal('list');
    });

    it('should include the line number of atoms', function () {
        var result = ast([['abc']]);
        var innerList = ast.expression(result, 0);
        ast.line(ast.expression(innerList, 0)).should.equal(1);
    });

    it('should include the column number of atoms', function () {
        var result = ast([['abc']]);
        var innerList = ast.expression(result, 0);
        ast.column(ast.expression(innerList, 0)).should.equal(2);

        result = ast([['abc', ['def']]]);
        var innerList = ast.expression(ast.expression(result, 0), 1);
        ast.column(ast.expression(innerList, 0)).should.equal(7);
    });
});
