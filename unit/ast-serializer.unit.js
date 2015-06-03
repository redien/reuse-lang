
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
var serialize = require('../lib/ast-serializer.js');
var ast = require('../lib/ast-builder');

describe('ast-serializer', function () {
    it('should serialize an atom x', function () {
        serialize(ast('x')).should.equal('x');
    });

    it('should serialize an empty list', function () {
        serialize(ast([])).should.equal('()');
    });

    it('should serialize a list with an atom in it', function () {
        serialize(ast(['a'])).should.equal('(a)');
    });

    it('should serialize a list nested inside another list', function () {
        serialize(ast([[]])).should.equal('(())');
    });

    it('should serialize a list with several atoms', function () {
        serialize(ast(['a', 'b', 'c'])).should.equal('(a b c)');
    });
});
