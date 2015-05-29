
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
    describe('parse', function () {
        it('should parse an empty string to null', function () {
            var result = parser.parse('');
            should(result.value).be.null;
        });

        it('should parse a program consisting of only whitespace to null', function () {
            var result = parser.parse('   \n\t   \r ');
            should(result.value).be.null;
        });

        it('should parse an empty list to {kind: "list", elements: []}', function () {
            var result = parser.parse('()');
            result.value.kind.should.equal('list');
            result.value.elements.should.be.Array;
            result.value.elements.length.should.equal(0);
        });

        it('should return an "unbalanced-parentheses" error given an opening brace without a closing one', function () {
            var result = parser.parse('(');
            should(result.error).not.be.null;
            result.error.message.should.equal('unbalanced-parentheses');
        });

        it('should return an "unbalanced-parentheses" error given too few closing braces', function () {
            var result = parser.parse('(()');
            should(result.error).not.be.null;
            result.error.message.should.equal('unbalanced-parentheses');
        });

        it('should return an error given an unexpected closing brace', function () {
            var result = parser.parse('((a) a))');
            should(result.error).not.be.null;

            result = parser.parse('2)');
            should(result.error).not.be.null;
        });

        it('should parse an atom named "atom" to {kind: "atom", value: "atom"}', function () {
            var result = parser.parse('atom');
            result.value.kind.should.equal('atom');
            result.value.value.should.equal('atom');
        });

        it('should parse an atom in a list into the list\'s elements array', function () {
            var result = parser.parse('(atom)');
            result.value.elements[0].kind.should.equal('atom');
        });

        it('should parse a list in a list into the first list\'s elements array', function () {
            var result = parser.parse('(())');
            result.value.elements[0].kind.should.equal('list');
        });

        it('should parse an atom nested in two lists', function () {
            var result = parser.parse('((atom))');
            result.value.kind.should.equal('list');
            result.value.elements[0].kind.should.equal('list');
            result.value.elements[0].elements[0].kind.should.equal('atom');
        });

        it('should parse atoms with any name', function () {
            var program = 'nameofsomeatom';
            var result = parser.parse(program);
            result.value.kind.should.equal('atom');
            result.value.value.should.equal(program);
        });

        it('should parse several atoms in a list', function () {
            var result = parser.parse('(atom atom)');
            result.value.elements[0].kind.should.equal('atom');
            result.value.elements[1].kind.should.equal('atom');
        });

        it('should parse mixed lists and atoms in a list', function () {
            var result = parser.parse('(atom (atom) atom)');
            result.value.elements[0].kind.should.equal('atom');
            result.value.elements[1].kind.should.equal('list');
            result.value.elements[1].elements[0].kind.should.equal('atom');
            result.value.elements[2].kind.should.equal('atom');
        });

        it('should handle arbitrary number of spaces', function () {
            var result = parser.parse('  (  atom ( atom) atom  )');
            result.value.elements[0].kind.should.equal('atom');
            result.value.elements[1].kind.should.equal('list');
            result.value.elements[1].elements[0].kind.should.equal('atom');
            result.value.elements[2].kind.should.equal('atom');
        });

        it('should treat new-lines and tabs as spaces', function () {
            var result = parser.parse('\t(\n\natom \n \r \n\r)');
            result.value.kind.should.equal('list');
            result.value.elements[0].kind.should.equal('atom');
        });
    });
});
