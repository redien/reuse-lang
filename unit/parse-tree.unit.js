
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
var pt = require('../lib/parse-tree');

describe('parse-tree', function () {
    describe('transform', function () {
        it('should transform an atom', function () {
            var parseTree = ast('abc');
            var result = pt.parse_tree_transform(parseTree, function () {
                return true;
            }, function () {
                return pt.parse_tree_atom('def', 0, 0);
            });

            pt.parse_tree_value(result).should.equal('def');
        });

        it('should transform an empty list', function () {
            var parseTree = ast([]);
            var result = pt.parse_tree_transform(parseTree, function () {
                return true;
            }, function () {
                return pt.parse_tree_atom('def', 0, 0);
            });

            pt.parse_tree_value(result).should.equal('def');
        });

        it('should transform an atom in a list', function () {
            var parseTree = ast(['abc']);
            var result = pt.parse_tree_transform(parseTree, function (expression) {
                return pt.parse_tree_kind(expression) === 'atom';
            }, function () {
                return pt.parse_tree_atom('def', 0, 0);
            });

            pt.parse_tree_kind(result).should.equal('list');
            pt.parse_tree_value(pt.parse_tree_child(result, 0)).should.equal('def');
        });

        it('should transform every matching expression in a list', function () {
            var parseTree = ast(['abc', [], 'def']);
            var result = pt.parse_tree_transform(parseTree, function (expression) {
                return pt.parse_tree_kind(expression) === 'atom';
            }, function () {
                return pt.parse_tree_atom('-', 0, 0);
            });

            pt.parse_tree_kind(result).should.equal('list');
            pt.parse_tree_value(pt.parse_tree_child(result, 0)).should.equal('-');
            pt.parse_tree_kind(pt.parse_tree_child(result, 1)).should.equal('list');
            pt.parse_tree_value(pt.parse_tree_child(result, 2)).should.equal('-');
        });

        it('should replace a hierarchy with another expression', function () {
            var parseTree = ast([['abc', []], ['def'], 'def']);
            var result = pt.parse_tree_transform(parseTree, function (expression) {
                return pt.parse_tree_count(expression) === 2;
            }, function () {
                return pt.parse_tree_atom('def', 0, 0);
            });

            pt.parse_tree_value(pt.parse_tree_child(result, 0)).should.equal('def');
            pt.parse_tree_value(pt.parse_tree_child(pt.parse_tree_child(result, 1), 0)).should.equal('def');
            pt.parse_tree_value(pt.parse_tree_child(result, 2)).should.equal('def');
        });

        it('should give the expression to be replaced to the transformer function', function () {
            var parseTree = ast(['abc']);
            var result = pt.parse_tree_transform(parseTree, function (expression) {
                return pt.parse_tree_kind(expression) === 'atom';
            }, function (atom) {
                return pt.parse_tree_push(pt.parse_tree_list(), atom);
            });

            pt.parse_tree_kind(result).should.equal('list');
            pt.parse_tree_kind(pt.parse_tree_child(result, 0)).should.equal('list');
            pt.parse_tree_value(pt.parse_tree_child(pt.parse_tree_child(result, 0), 0)).should.equal('abc');
        });
    });
});
