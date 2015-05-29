
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

describe('Errors', function () {
    it('should given too many opening parentheses return an unbalanced-parentheses error', function (done) {
        reuse.evaluate('(()', function (error, value) {
            should(error).not.be.null;

            error.message.should.equal('unbalanced-parentheses');
            done();
        });
    });
});
