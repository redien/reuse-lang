
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

describe('Lambda', function () {
    describe('Evaluation', function () {
        it('should evaluate ((lambda () ())) to []', function (done) {
            reuse.evaluate('((lambda () ()))', function (value) {
                value.should.be.Array;
                value.length.should.equal(0);
                return done();
            });
        });

        it('should evaluate ((lambda () 42)) to 42', function (done) {
            reuse.evaluate('((lambda () 42))', function (value) {
                value.should.equal(42);
                return done();
            });
        });
    });
    
    describe('Variable Binding', function () {
        it('should evaluate ((lambda (x) x) 33) to 33', function (done) {
            reuse.evaluate('((lambda (x) x) 33)', function (value) {
                value.should.equal(33);
                return done();
            });
        });

        it('should evaluate ((lambda (x y) x) 22 33) to 22', function (done) {
            reuse.evaluate('((lambda (x y) x) 22 33)', function (value) {
                value.should.equal(22);
                return done();
            });
        });

        it('should evaluate ((lambda (x y) y) 22 33) to 33', function (done) {
            reuse.evaluate('((lambda (x y) y) 22 33)', function (value) {
                value.should.equal(33);
                return done();
            });
        });
    });
    
    describe('Nested Declarations', function () {
        it('should evaluate (((lambda (x) (lambda (y) y)) 33) 22) to 22', function (done) {
            reuse.evaluate('(((lambda (x) (lambda (y) y)) 33) 22)', function (value) {
                value.should.equal(22);
                return done();
            });
        });
    });
});
