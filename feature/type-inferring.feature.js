
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
var reuse = require('../lib/reuse.js');

describe('Type Inferring', function () {
    describe('Literals', function () {
        it('should generated type int32 given 42', function () {
            var ast = reuse.generateTypedAst('42');
            ast.type.should.equal('int32');
        });

        it('should generated type int32 given -34', function () {
            var ast = reuse.generateTypedAst('-34');
            ast.type.should.equal('int32');
        });

        it('should generated type () given ()', function () {
            var ast = reuse.generateTypedAst('()');
            ast.type.should.equal('()');
        });
    });
});
