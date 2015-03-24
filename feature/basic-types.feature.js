
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
var reuse = require('../lib/reuse.js');

describe('Basic Types', function () {
    describe('int32', function () {
        it('should evaluate to itself', function (done) {
            reuse.evaluate('3', function (value) {
                value.should.equal(3);
                return done();
            });
        });

        it('should include negative numbers', function (done) {
            reuse.evaluate('-42', function (value) {
                value.should.equal(-42);
                return done();
            });
        });
    });

    describe('list', function () {
        it('should evaluate () to []', function (done) {
            reuse.evaluate('()', function (value) {
                value.should.be.Array;
                value.length.should.equal(0);
                return done();
            });
        });
    });
});
