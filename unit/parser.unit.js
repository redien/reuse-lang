
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

var ast_should_be_empty_list = function (ast) {
    ast.kind.should.equal('list');
    ast.elements.should.be.Array;
    ast.elements.length.should.equal(0);
};

describe('parser', function () {
    it('should return no asts given an empty string', function () {
        var result = parser.parse('');
        result.asts.should.be.Array;
        result.asts.length.should.equal(0);
    });

    it('should return no asts given a program consisting of only whitespace', function () {
        var result = parser.parse('   \n\t   \r ');
        result.asts.should.be.Array;
        result.asts.length.should.equal(0);
    });

    it('should parse () to {kind: "list", elements: []}', function () {
        var result = parser.parse('()');
        ast_should_be_empty_list(result.asts[0]);
    });

    it('should parse an atom named "something" to {kind: "atom", value: "something"}', function () {
        var result = parser.parse('something');
        result.asts[0].kind.should.equal('atom');
        result.asts[0].value.should.equal('something');
    });

    it('should parse atoms with any name', function () {
        var program = 'nameofsomeatom';
        var result = parser.parse(program);
        result.asts[0].kind.should.equal('atom');
        result.asts[0].value.should.equal(program);
    });

    it('should parse a program of several asts and return them', function () {
        var result = parser.parse('(b c) a');
        result.asts[0].kind.should.equal('list');
        result.asts[1].kind.should.equal('atom');
    });

    it('should return an "unbalanced-parentheses" error given an opening brace without a closing one', function () {
        var result = parser.parse('(');
        result.error.message.should.equal('unbalanced-parentheses');
    });

    it('should return an "unbalanced-parentheses" error given too few closing braces', function () {
        var result = parser.parse('(()');
        result.error.message.should.equal('unbalanced-parentheses');
    });

    it('should return an "unbalanced-parentheses" error given an unexpected closing brace', function () {
        var result = parser.parse('((a) a))');
        result.error.message.should.equal('unbalanced-parentheses');

        result = parser.parse('2)');
        result.error.message.should.equal('unbalanced-parentheses');
    });

    it('should not allow (\'s in atoms', function () {
        var result = parser.parse('(abc()');
        should(result.error).not.be.null;
    });

    it('should parse (atom)', function () {
        var result = parser.parse('(atom)');
        result.asts[0].elements[0].kind.should.equal('atom');
    });

    it('should parse (())', function () {
        var result = parser.parse('(())');
        result.asts[0].elements[0].kind.should.equal('list');
    });

    it('should parse ((atom))', function () {
        var result = parser.parse('((atom))');
        result.asts[0].kind.should.equal('list');
        result.asts[0].elements[0].kind.should.equal('list');
        result.asts[0].elements[0].elements[0].kind.should.equal('atom');
    });

    it('should parse (atom atom)', function () {
        var result = parser.parse('(atom atom)');
        result.asts[0].elements[0].kind.should.equal('atom');
        result.asts[0].elements[1].kind.should.equal('atom');
    });

    it('should parse (atom (atom) atom)', function () {
        var result = parser.parse('(atom (atom) atom)');
        result.asts[0].elements[0].kind.should.equal('atom');
        result.asts[0].elements[1].kind.should.equal('list');
        result.asts[0].elements[1].elements[0].kind.should.equal('atom');
        result.asts[0].elements[2].kind.should.equal('atom');
    });

    it('should handle arbitrary number of spaces', function () {
        var result = parser.parse('  (  atom ( atom) atom  )');
        result.asts[0].elements[0].kind.should.equal('atom');
        result.asts[0].elements[1].kind.should.equal('list');
        result.asts[0].elements[1].elements[0].kind.should.equal('atom');
        result.asts[0].elements[2].kind.should.equal('atom');
    });

    it('should treat new-lines and tabs as spaces', function () {
        var result = parser.parse('\t(\n\natom \n \r \n\r)');
        result.asts[0].kind.should.equal('list');
        result.asts[0].elements[0].kind.should.equal('atom');
    });

    it('should assign line information to atoms', function () {
        var result = parser.parse('\n\n(atom)\n');
        result.asts[0].elements[0].line.should.equal(3);
    });

    it('should assign column information to atoms', function () {
        var result = parser.parse('\n(atom)\n');
        result.asts[0].elements[0].column.should.equal(2);
    });
});
