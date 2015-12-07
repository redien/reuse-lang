
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
var pts = require('../lib/parse-tree-serializer');

describe('parse-tree-serializer', function () {
    it('should serialize an atom', function () {
        var parseTree = ast('abc');
        var result = pts.parse_tree_serializer_serialize(parseTree);
        result.should.equal('abc');
    });

    it('should serialize an empty list', function () {
        var parseTree = ast([]);
        var result = pts.parse_tree_serializer_serialize(parseTree);
        result.should.equal('()');
    });

    it('should serialize a list with one atom', function () {
        var parseTree = ast(['efg']);
        var result = pts.parse_tree_serializer_serialize(parseTree);
        result.should.equal('(efg)');
    });

    it('should serialize a list with several atoms', function () {
        var parseTree = ast(['abc', 'def', 'ghi']);
        var result = pts.parse_tree_serializer_serialize(parseTree);
        result.should.equal('(abc def ghi)');
    });

    it('should serialize an empty list within a list', function () {
        var parseTree = ast(['abc', [], 'ghi']);
        var result = pts.parse_tree_serializer_serialize(parseTree);
        result.should.equal('(abc () ghi)');
    });

    it('should serialize a deep hiearchy of lists and atoms', function () {
        var parseTree = ast(['abc', [['abc', 'ddd'], '2'], ['ghi']]);
        var result = pts.parse_tree_serializer_serialize(parseTree);
        result.should.equal('(abc ((abc ddd) 2) (ghi))');
    });
});
