
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
var parser = require('../lib/parser');
var ast = require('../lib/ast-builder');

describe('parser', function () {
    it('should return no asts given an empty string', function () {
        var result = parser.value(parser.parse(''));
        ast.count(result).should.equal(0);
    });

    it('should return no asts given a program consisting of only whitespace', function () {
        var result = parser.value(parser.parse('   \n\t   \r '));
        ast.count(result).should.equal(0);
    });

    it('should parse ()', function () {
        var result = parser.value(parser.parse('()'));
        ast.kind(ast.expression(result, 0)).should.equal('list');
        ast.count(ast.expression(result, 0)).should.equal(0);
    });

    it('should parse an atom named "something"', function () {
        var result = parser.value(parser.parse('something'));
        ast.kind(ast.expression(result, 0)).should.equal('atom');
        ast.value(ast.expression(result, 0)).should.equal('something');
    });

    it('should parse atoms with any name', function () {
        var program = 'nameofsomeatom';
        var result = parser.value(parser.parse(program));
        ast.kind(ast.expression(result, 0)).should.equal('atom');
        ast.value(ast.expression(result, 0)).should.equal(program);
    });

    it('should parse a program of several asts and return them', function () {
        var result = parser.value(parser.parse('(b c) a'));
        ast.kind(ast.expression(result, 0)).should.equal('list');
        ast.kind(ast.expression(result, 1)).should.equal('atom');
    });

    it('should return an "unbalanced_parentheses" error given an opening brace without a closing one', function () {
        var result = parser.parse('(');
        parser.errorType(result).should.equal('unbalanced_parentheses');
    });

    it('should return an "unbalanced_parentheses" error given too few closing braces', function () {
        var result = parser.parse('(()');
        parser.errorType(result).should.equal('unbalanced_parentheses');
    });

    it('should return an "unbalanced_parentheses" error given an unexpected closing brace', function () {
        var result = parser.parse('((a) a))');
        parser.errorType(result).should.equal('unbalanced_parentheses');

        result = parser.parse('2)');
        parser.errorType(result).should.equal('unbalanced_parentheses');
    });

    it('should parse (atom)', function () {
        var result = parser.value(parser.parse('(atom)'));
        ast.kind(ast.expression(ast.expression(result, 0), 0)).should.equal('atom');
    });

    it('should parse (())', function () {
        var result = parser.value(parser.parse('(())'));
        ast.kind(ast.expression(ast.expression(result, 0), 0)).should.equal('list');
    });

    it('should parse ((atom))', function () {
        var result = parser.value(parser.parse('((atom))'));
        ast.kind(ast.expression(result, 0)).should.equal('list');
        ast.kind(ast.expression(ast.expression(result, 0), 0)).should.equal('list');
        ast.kind(ast.expression(ast.expression(ast.expression(result, 0), 0), 0)).should.equal('atom');
    });

    it('should parse (atom atom)', function () {
        var result = parser.value(parser.parse('(atom atom)'));
        ast.kind(ast.expression(ast.expression(result, 0), 0)).should.equal('atom');
        ast.kind(ast.expression(ast.expression(result, 0), 1)).should.equal('atom');
    });

    it('should parse (atom (atom) atom)', function () {
        var result = parser.value(parser.parse('(atom (atom) atom)'));
        ast.kind(ast.expression(ast.expression(result, 0), 0)).should.equal('atom');
        ast.kind(ast.expression(ast.expression(result, 0), 1)).should.equal('list');
        ast.kind(ast.expression(ast.expression(ast.expression(result, 0), 1), 0)).should.equal('atom');
        ast.kind(ast.expression(ast.expression(result, 0), 2)).should.equal('atom');
    });

    it('should handle arbitrary number of spaces', function () {
        var result = parser.value(parser.parse('  (  atom ( atom) atom  )'));
        ast.kind(ast.expression(ast.expression(result, 0), 0)).should.equal('atom');
        ast.kind(ast.expression(ast.expression(result, 0), 1)).should.equal('list');
        ast.kind(ast.expression(ast.expression(ast.expression(result, 0), 1), 0)).should.equal('atom');
        ast.kind(ast.expression(ast.expression(result, 0), 2)).should.equal('atom');
    });

    it('should treat new-lines and tabs as spaces', function () {
        var result = parser.value(parser.parse('\t(\n\natom \n \r \n\r)'));
        ast.kind(ast.expression(result, 0)).should.equal('list');
        ast.kind(ast.expression(ast.expression(result, 0), 0)).should.equal('atom');
    });

    it('should treat all unicode space characters as spaces', function () {
        var result = parser.value(parser.parse('(atom \u00A0\u1680\u180E\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u200B\u202F\u205F\u3000\uFEFF atom)'));
        ast.kind(ast.expression(result, 0)).should.equal('list');
        ast.value(ast.expression(ast.expression(result, 0), 0)).should.equal('atom');
        ast.value(ast.expression(ast.expression(result, 0), 1)).should.equal('atom');
    });

    it('should assign line information to atoms', function () {
        var result = parser.value(parser.parse('\n\n(atom)\n'));
        ast.line(ast.expression(ast.expression(result, 0), 0)).should.equal(3);
    });

    it('should assign column information to atoms', function () {
        var result = parser.value(parser.parse('\n(atom)\n'));
        ast.column(ast.expression(ast.expression(result, 0), 0)).should.equal(2);
    });
});
