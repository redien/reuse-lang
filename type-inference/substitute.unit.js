
var Immutable = require('immutable');
var should = require('should');
var infer = require('./substitute');
var Type = require('./type');

describe('Type substitution', function () {
    it('should return a given a and []', function () {
        var type = Type.constant('a');
        var constraints = Immutable.List();

        var result = infer.substitute(type, constraints);

        result.isConstant.should.be.true();
        result.name.should.equal('a');
    });

    it('should return b given X and [X b]', function () {
        var type = Type.variable('X');
        var constraints = Immutable.List.of(
            [Type.variable('X'), Type.constant('b')]
        );

        var result = infer.substitute(type, constraints);

        result.isConstant.should.be.true();
        result.name.should.equal('b');
    });

    it('should return (lambda (a b) c) given (lambda (X Y) Z) and [X a Y b Z c]', function () {
        var type = Type.lambda(Immutable.List.of(Type.variable('X'), Type.variable('Y')), Type.variable('Z'));
        var constraints = Immutable.List.of(
            [Type.variable('X'), Type.constant('a')],
            [Type.variable('Y'), Type.constant('b')],
            [Type.variable('Z'), Type.constant('c')]
        );

        var result = infer.substitute(type, constraints);

        result.isLambda.should.be.true();
        result.parameterTypes.get(0).isConstant.should.be.true();
        result.parameterTypes.get(0).name.should.equal('a');
        result.parameterTypes.get(1).isConstant.should.be.true();
        result.parameterTypes.get(1).name.should.equal('b');
        result.returnType.isConstant.should.be.true();
        result.returnType.name.should.equal('c');
    });

    it('should return (lambda (X) b) given (lambda (X) Y) and [X a Y b Z c]', function () {
        var type = Type.lambda(Immutable.List.of(Type.variable('X')), Type.variable('Y'));
        var constraints = Immutable.List.of(
            [Type.variable('X'), Type.constant('a')],
            [Type.variable('Y'), Type.constant('b')],
            [Type.variable('Z'), Type.constant('c')]
        );

        var result = infer.substitute(type, constraints);

        result.isLambda.should.be.true();
        result.parameterTypes.get(0).isConstant.should.be.true();
        result.parameterTypes.get(0).name.should.equal('a');
        result.returnType.isConstant.should.be.true();
        result.returnType.name.should.equal('b');
    });
});
