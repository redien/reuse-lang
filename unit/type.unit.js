
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
var type = require('../lib/type');

describe('type', function () {
    describe('constant', function () {
        it('should return a constant with the specified name as parameter name', function () {
            var constant = type.constant('int32');
            constant.kind.should.equal('constant');
            constant.name.should.equal('int32');

            constant = type.constant('()');
            constant.name.should.equal('()');
        });
    });

    describe('tuple', function () {
        it('should return a tuple with the specified types as parameters first and second', function () {
            var tuple = type.tuple(
                type.constant('int32'),
                type.constant('()')
            );
            tuple.kind.should.equal('tuple');
            tuple.first.kind.should.equal('constant');
            tuple.first.name.should.equal('int32');
            tuple.second.kind.should.equal('constant');
            tuple.second.name.should.equal('()');

            tuple = type.tuple(
                type.constant('()'),
                type.constant('int32')
            );
            tuple.first.name.should.equal('()');
            tuple.second.name.should.equal('int32');
        });
    });

    describe('list', function () {
        it('should return a list of the specified type as parameter type', function () {
            var list = type.list(
                type.constant('int32')
            );
            list.kind.should.equal('list');
            list.type.kind.should.equal('constant');
            list.type.name.should.equal('int32');

            list = type.list(
                type.constant('()')
            );
            list.type.name.should.equal('()');
        });
    });

    describe('variable', function () {
        it('should return a unique type variable', function () {
            var variable = type.variable();
            variable.kind.should.equal('variable');

            var otherVariable = type.variable();
            variable.should.not.equal(otherVariable);
        });
    });

    describe('equals', function () {
        it('should be false given two different kinds of types', function () {
            type.equals(
                type.list(type.constant('int32')),
                type.constant('int32')
            ).should.be.false;
        });

        it('should be true give two constants with the same name', function () {
            type.equals(
                type.constant('int32'),
                type.constant('int32')
            ).should.be.true;
        });

        it('should be false given two constants with different names', function () {
            type.equals(
                type.constant('int32'),
                type.constant('()')
            ).should.be.false;
        });

        it('should be false given two different variables', function () {
            type.equals(
                type.variable(),
                type.variable()
            ).should.be.false;
        });

        it('should be true given the same variable', function () {
            var variable = type.variable();
            type.equals(
                variable,
                variable
            ).should.be.true;
        });

        it('should be false given two lists of unequal types', function () {
            type.equals(
                type.list(type.list(type.constant('int32'))),
                type.list(type.list(type.constant('()')))
            ).should.be.false;
        });

        it('should be true given two lists of equal types', function () {
            type.equals(
                type.list(type.list(type.constant('int32'))),
                type.list(type.list(type.constant('int32')))
            ).should.be.true;
        });

        it('should be false given two tuples of two unequal pairs of types', function () {
            type.equals(
                type.tuple(
                    type.list(type.constant('int32')),
                    type.variable()
                ),
                type.tuple(
                    type.list(type.constant('int32')),
                    type.list(type.variable())
                )
            ).should.be.false;
        });

        it('should be true given two tuples of two equal pairs of types', function () {
            var variable = type.variable();
            type.equals(
                type.tuple(
                    type.list(type.constant('()')),
                    variable
                ),
                type.tuple(
                    type.list(type.constant('()')),
                    variable
                )
            ).should.be.true;
        });
    });
});
