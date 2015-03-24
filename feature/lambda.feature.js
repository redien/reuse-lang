
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
            reuse.evaluate('((lambda () ()))', function (error, value) {
                value.should.be.Array;
                value.length.should.equal(0);
                return done();
            });
        });

        it('should evaluate ((lambda () 1)) to 1', function (done) {
            reuse.evaluate('((lambda () 1))', function (error, value) {
                value.should.equal(1);
                return done();
            });
        });

        it('should evaluate (((lambda (f) f) (lambda () 2))) to 2', function (done) {
            reuse.evaluate('(((lambda (f) f) (lambda () 2)))', function (error, value) {
                value.should.equal(2);
                return done();
            });
        });
    });
    
    describe('Variable Binding', function () {
        it('should evaluate ((lambda (x) x) 3) to 3', function (done) {
            reuse.evaluate('((lambda (x) x) 3)', function (error, value) {
                value.should.equal(3);
                return done();
            });
        });

        it('should evaluate ((lambda (x y) x) 4 5) to 4', function (done) {
            reuse.evaluate('((lambda (x y) x) 4 5)', function (error, value) {
                value.should.equal(4);
                return done();
            });
        });

        it('should evaluate ((lambda (x y) y) 6 7) to 7', function (done) {
            reuse.evaluate('((lambda (x y) y) 6 7)', function (error, value) {
                value.should.equal(7);
                return done();
            });
        });
    });

    describe('Nested Declarations', function () {
        it('should evaluate (((lambda (x) (lambda (y) y)) 8) 9) to 9', function (done) {
            reuse.evaluate('(((lambda (x) (lambda (y) y)) 8) 9)', function (error, value) {
                value.should.equal(9);
                return done();
            });
        });
    });
});
