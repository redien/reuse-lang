
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
var i32Constructor = require('../lib/i32-constructor');

describe('i32-constructor', function () {
    it('should give an atom 32 type i32', function () {
        var result = i32Constructor(ast('32'));
        result.isConstant.should.equal(true);
        result.type.value.should.equal('i32');
    });

    it('should give an atom -0 type i32', function () {
        var result = i32Constructor(ast('-0'));
        result.isConstant.should.equal(true);
        result.type.value.should.equal('i32');
        result.value.should.equal('-0');
    });

    it('should not give an atom 0a type i32', function () {
        var result = i32Constructor(ast('0a'));
        should(result.isConstant).not.equal(true);
    });

    it('should not give an atom foo9 type i32', function () {
        var result = i32Constructor(ast('foo9'));
        should(result.isConstant).not.equal(true);
    });

    it('should not give an atom f23b type i32', function () {
        var result = i32Constructor(ast('f23b'));
        should(result.isConstant).not.equal(true);
    });

    it('should throw error "i32_constant_too_large" given 2147483648', function () {
        var error;
        try {
            var result = i32Constructor(ast('2147483648'));
        } catch (e) {
            error = e;
        }

        error.message.should.equal('i32_constant_too_large');
    });

    it('should throw error "i32_constant_too_small" given -2147483649', function () {
        var error;
        try {
            var result = i32Constructor(ast('-2147483649'));
        } catch (e) {
            error = e;
        }

        error.message.should.equal('i32_constant_too_small');
    });
});
