
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
var ast = require('../lib/ast-builder.js');

describe('astBuilder', function () {
    it('should return an atom given the string "abc"', function () {
        ast('abc').kind.should.equal('atom');
    });

    it('should return a value "cba" given the string "cba"', function () {
        ast('cba').value.should.equal('cba');
    });

    it('should return a list given []', function () {
        ast([]).kind.should.equal('list');
    });

    it('should return a list of atom "123" given ["123"]', function () {
        ast(["123"]).elements[0].value.should.equal('123');
    });

    it('should return a list of atom "123", "234" and "0" given ["123", "234", "0"]', function () {
        var result = ast(['123', '234', '0']);
        result.elements[0].value.should.equal('123');
        result.elements[1].value.should.equal('234');
        result.elements[2].value.should.equal('0');
    });

    it('should return a list of a list given [[]]', function () {
        ast([[]]).elements[0].kind.should.equal('list');
    });
});
