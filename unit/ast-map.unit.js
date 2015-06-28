
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
var map = require('../lib/ast-map');

var constructTestFunction = function (constant) {
    return function () {
        return ast(constant);
    };
};

describe('ast-map', function () {
    it('should given () -> 3 and an atom foo give an atom 3', function () {
        var result = map(constructTestFunction('3'), ast('foo'));
        result.value.should.equal('3');
    });

    it('should given () -> 4 and (a b c) give (4 4 4)', function () {
        var result = map(constructTestFunction('4'), ast(['a', 'b', 'c']));
        result.elements[0].value.should.equal('4');
        result.elements[1].value.should.equal('4');
        result.elements[2].value.should.equal('4');
    });

    it('should given () -> 5 and (a (b) c) give (5 (5) 5)', function () {
        var result = map(constructTestFunction('5'), ast(['a', ['b'], 'c']));
        result.elements[0].value.should.equal('5');
        result.elements[1].elements[0].value.should.equal('5');
        result.elements[2].value.should.equal('5');
    });
});
