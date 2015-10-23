
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

describe('parser', function () {
    it('should return no asts given an empty string', function () {
        var result = parser.parse('');
        result.elements.should.be.Array;
        result.elements.length.should.equal(0);
    });

    it('should return no asts given a program consisting of only whitespace', function () {
        var result = parser.parse('   \n\t   \r ');
        result.elements.should.be.Array;
        result.elements.length.should.equal(0);
    });

    it('should parse () to {kind: "list", elements: []}', function () {
        var result = parser.parse('()');
        result.elements[0].kind.should.equal('list');
        result.elements[0].elements.should.be.Array;
        result.elements[0].elements.length.should.equal(0);
    });

    it('should parse an atom named "something" to {kind: "atom", value: "something"}', function () {
        var result = parser.parse('something');
        result.elements[0].kind.should.equal('atom');
        result.elements[0].value.should.equal('something');
    });

    it('should parse atoms with any name', function () {
        var program = 'nameofsomeatom';
        var result = parser.parse(program);
        result.elements[0].kind.should.equal('atom');
        result.elements[0].value.should.equal(program);
    });

    it('should parse a program of several asts and return them', function () {
        var result = parser.parse('(b c) a');
        result.elements[0].kind.should.equal('list');
        result.elements[1].kind.should.equal('atom');
    });

    it('should return an "unbalanced_parentheses" error given an opening brace without a closing one', function () {
        var result = parser.parse('(');
        result.error.message.should.equal('unbalanced_parentheses');
    });

    it('should return an "unbalanced_parentheses" error given too few closing braces', function () {
        var result = parser.parse('(()');
        result.error.message.should.equal('unbalanced_parentheses');
    });

    it('should return an "unbalanced_parentheses" error given an unexpected closing brace', function () {
        var result = parser.parse('((a) a))');
        result.error.message.should.equal('unbalanced_parentheses');

        result = parser.parse('2)');
        result.error.message.should.equal('unbalanced_parentheses');
    });

    it('should return an "expected_whitespace" error given an opening brace directly after an atom', function () {
        var result = parser.parse('(abc())');
        result.error.message.should.equal('expected_whitespace');
    });

    it('should return an "expected_whitespace" error given a closing brace directly before an atom', function () {
        var result = parser.parse('(()abc)');
        result.error.message.should.equal('expected_whitespace');
    });

    it('should return an "expected_whitespace" error given a closing brace directly before an opening brace', function () {
        var result = parser.parse('(()())');
        result.error.message.should.equal('expected_whitespace');
    });

    it('should parse (atom)', function () {
        var result = parser.parse('(atom)');
        result.elements[0].elements[0].kind.should.equal('atom');
    });

    it('should parse (())', function () {
        var result = parser.parse('(())');
        result.elements[0].elements[0].kind.should.equal('list');
    });

    it('should parse ((atom))', function () {
        var result = parser.parse('((atom))');
        result.elements[0].kind.should.equal('list');
        result.elements[0].elements[0].kind.should.equal('list');
        result.elements[0].elements[0].elements[0].kind.should.equal('atom');
    });

    it('should parse (atom atom)', function () {
        var result = parser.parse('(atom atom)');
        result.elements[0].elements[0].kind.should.equal('atom');
        result.elements[0].elements[1].kind.should.equal('atom');
    });

    it('should parse (atom (atom) atom)', function () {
        var result = parser.parse('(atom (atom) atom)');
        result.elements[0].elements[0].kind.should.equal('atom');
        result.elements[0].elements[1].kind.should.equal('list');
        result.elements[0].elements[1].elements[0].kind.should.equal('atom');
        result.elements[0].elements[2].kind.should.equal('atom');
    });

    it('should handle arbitrary number of spaces', function () {
        var result = parser.parse('  (  atom ( atom) atom  )');
        result.elements[0].elements[0].kind.should.equal('atom');
        result.elements[0].elements[1].kind.should.equal('list');
        result.elements[0].elements[1].elements[0].kind.should.equal('atom');
        result.elements[0].elements[2].kind.should.equal('atom');
    });

    it('should treat new-lines and tabs as spaces', function () {
        var result = parser.parse('\t(\n\natom \n \r \n\r)');
        result.elements[0].kind.should.equal('list');
        result.elements[0].elements[0].kind.should.equal('atom');
    });

    it('should treat all unicode space characters as spaces', function () {
        var result = parser.parse('(atom \u00A0\u1680\u180E\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u200B\u202F\u205F\u3000\uFEFF atom)')
        result.elements[0].kind.should.equal('list');
        result.elements[0].elements[0].value.should.equal('atom');
        result.elements[0].elements[1].value.should.equal('atom');
    });

    it('should assign line information to atoms', function () {
        var result = parser.parse('\n\n(atom)\n');
        result.elements[0].elements[0].line.should.equal(3);
    });

    it('should assign column information to atoms', function () {
        var result = parser.parse('\n(atom)\n');
        result.elements[0].elements[0].column.should.equal(2);
    });
});
