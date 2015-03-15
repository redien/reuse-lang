
// reuse-lang - a pure functional lisp-like language for writing
// reusable business-logic in an extremely portable way.
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
        it('should parse an empty string to null', function (done) {
            parser.parse('', function (error, parsedProgram) {
                should(parsedProgram).be.null;
                return done();
            });
        });

        it('should parse an empty list to {kind: "list", elements: []}', function (done) {
            parser.parse('()', function (error, parsedProgram) {
                parsedProgram.kind.should.equal('list');
                parsedProgram.elements.should.be.Array;
                parsedProgram.elements.length.should.equal(0);
                return done();
            });
        });

        it('should return an error given an opening brace without a closing one', function (done) {
            parser.parse('(', function (error, parsedProgram) {
                should(error).not.be.null;
                return done();
            });
        });

        it('should return an error given an unexpected closing brace', function (done) {
            parser.parse('((a) a))', function (error, parsedProgram) {
                should(error).not.be.null;

                parser.parse('2)', function (error, parsedProgram) {
                    should(error).not.be.null;
                    return done();
                });
            });
        });

        it('should parse an atom named "atom" to {kind: "atom", value: "atom"}', function (done) {
            parser.parse('atom', function (error, parsedProgram) {
                parsedProgram.kind.should.equal('atom');
                parsedProgram.value.should.equal('atom');
                return done();
            });
        });

        it('should parse an atom in a list into the list\'s elements array', function (done) {
            parser.parse('(atom)', function (error, parsedProgram) {
                parsedProgram.elements[0].kind.should.equal('atom');
                return done();
            });
        });

        it('should parse a list in a list into the first list\'s elements array', function (done) {
            parser.parse('(())', function (error, parsedProgram) {
                parsedProgram.elements[0].kind.should.equal('list');
                return done();
            });
        });

        it('should parse an atom nested in two lists', function (done) {
            parser.parse('((atom))', function (error, parsedProgram) {
                parsedProgram.kind.should.equal('list');
                parsedProgram.elements[0].kind.should.equal('list');
                parsedProgram.elements[0].elements[0].kind.should.equal('atom');
                return done();
            });
        });

        it('should parse atoms with any name', function (done) {
            var program = 'nameofsomeatom';
            parser.parse(program, function (error, parsedProgram) {
                parsedProgram.kind.should.equal('atom');
                parsedProgram.value.should.equal(program);
                return done();
            });
        });

        it('should parse several atoms in a list', function (done) {
            parser.parse('(atom atom)', function (error, parsedProgram) {
                parsedProgram.elements[0].kind.should.equal('atom');
                parsedProgram.elements[1].kind.should.equal('atom');
                return done();
            });
        });

        it('should parse mixed lists and atoms in a list', function (done) {
            parser.parse('(atom (atom) atom)', function (error, parsedProgram) {
                parsedProgram.elements[0].kind.should.equal('atom');
                parsedProgram.elements[1].kind.should.equal('list');
                parsedProgram.elements[1].elements[0].kind.should.equal('atom');
                parsedProgram.elements[2].kind.should.equal('atom');
                return done();
            });
        });
        
        it('should handle arbitrary number of spaces', function (done) {
            parser.parse('  (  atom ( atom) atom  )', function (error, parsedProgram) {
                parsedProgram.elements[0].kind.should.equal('atom');
                parsedProgram.elements[1].kind.should.equal('list');
                parsedProgram.elements[1].elements[0].kind.should.equal('atom');
                parsedProgram.elements[2].kind.should.equal('atom');
                return done();
            });
        });
        
        it('should treat new-lines and tabs as spaces', function (done) {
            parser.parse('\t(\n\natom \n \r \n\r)', function (error, parsedProgram) {
                parsedProgram.kind.should.equal('list');
                parsedProgram.elements[0].kind.should.equal('atom');
                return done();
            });
        });
    });
});
