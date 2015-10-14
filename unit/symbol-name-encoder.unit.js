
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
var encoder = require('../lib/symbol-name-encoder');

describe('symbol-name-encoder', function () {
    it('should encode a name with any character into one with only [a-zA-Z0-9_]', function () {
        var result = encoder.encode('?"(#Ö:ªç');
        result.should.match(/^[a-zA-Z0-9_]+$/);
    });

    it('should keep characters [a-zA-Z] as they are.', function () {
        var result = encoder.encode('abcª123');
        result.should.match(/^abc[a-zA-Z0-9_]+$/);
    });

    it('should encode digits', function () {
        var result = encoder.encode('123');
        result.should.not.equal('123');
    });
});
