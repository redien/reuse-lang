
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
var validator = require('../lib/validator');

describe('validator', function () {
    describe('validate', function () {
        it('should return an error given too many arguments to a function call', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'lambda'},
                        {kind: 'list', elements: [
                            {kind: 'atom', value: 'x'}
                        ]},
                        {kind: 'atom', value: 'x'}
                    ]},
                    {kind: 'atom', value: '42'},
                    {kind: 'atom', value: '5'}
                ]};

            validator.validate(parsedProgram, function (error) {
                should(error).not.be.null;
                error.type.should.equal('TooManyArguments');
                return done();
            });
        });

        it('should return an error given too few arguments to a function call', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'lambda'},
                        {kind: 'list', elements: [
                            {kind: 'atom', value: 'x'}
                        ]},
                        {kind: 'atom', value: 'x'}
                    ]}
                ]};

            validator.validate(parsedProgram, function (error) {
                should(error).not.be.null;
                error.type.should.equal('TooFewArguments');
                return done();
            });
        });

        it('should return an unbound variable error given x', function (done) {
            var parsedProgram = {kind: 'atom', value: 'x'};

            validator.validate(parsedProgram, function (error) {
                should(error).not.be.null;
                error.type.should.equal('UnboundVariable');
                return done();
            });
        });

        it('should return an unbound variable error given (lambda () x)', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'atom', value: 'lambda'},
                    {kind: 'list', elements: []},
                    {kind: 'atom', value: 'x'}
                ]};

            validator.validate(parsedProgram, function (error) {
                should(error).not.be.null;
                error.type.should.equal('UnboundVariable');
                return done();
            });
        });

        it('should return an unbound variable error given (lambda () (x))', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'atom', value: 'lambda'},
                    {kind: 'list', elements: []},
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'x'}
                    ]}
                ]};

            validator.validate(parsedProgram, function (error) {
                should(error).not.be.null;
                error.type.should.equal('UnboundVariable');
                return done();
            });
        });

        it('should return an unbound variable error given (lambda (x) (x y))', function (done) {
            var parsedProgram =
                {kind: 'list', elements: [
                    {kind: 'atom', value: 'lambda'},
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'x'},
                    ]},
                    {kind: 'list', elements: [
                        {kind: 'atom', value: 'x'},
                        {kind: 'atom', value: 'y'}
                    ]}
                ]};

            validator.validate(parsedProgram, function (error) {
                should(error).not.be.null;
                error.type.should.equal('UnboundVariable');
                return done();
            });
        });
    });
});
