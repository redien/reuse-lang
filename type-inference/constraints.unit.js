
var Immutable = require('immutable');
var should = require('should');
var infer = require('./constraints');

var ast = require('../parser/ast');
var Type = require('./type');

describe('Type constraints', function () {
    it('should return integer and [] given 1 and []', function () {
        var expression = ast.atom('1');
        var constraints = Immutable.List();

        var result = infer.constraints(expression, constraints);

        result.type.isConstant.should.be.true();
        result.type.name.should.equal('integer');
        result.constraints.size.should.equal(0);
    });

    it('should return integer and [] given a and [a integer]', function () {
        var expression = ast.atom('a');
        var constraints = Immutable.List.of(
            [Type.variable('a'), Type.constant('integer')]
        );

        var result = infer.constraints(expression, constraints);

        result.type.isConstant.should.be.true();
        result.type.name.should.equal('integer');
        result.constraints.size.should.equal(0);
    });

    it('should return integer and [] given a and [b _ a integer]', function () {
        var expression = ast.atom('a');
        var constraints = Immutable.List.of(
            [Type.variable('b'), Type.variable('_')],
            [Type.variable('a'), Type.constant('integer')]
        );

        var result = infer.constraints(expression, constraints);

        result.type.isConstant.should.be.true();
        result.type.name.should.equal('integer');
        result.constraints.size.should.equal(0);
    });

    it('should return a and [] given a and []', function () {
        var expression = ast.atom('a');
        var constraints = Immutable.List();

        var result = infer.constraints(expression, constraints);

        result.type.isVariable.should.be.true();
        result.type.name.should.equal('a');
        result.constraints.size.should.equal(0);
    });

    it('should return (lambda (_1) _1) and [] given (lambda (x) x) and []', function () {
        var expression = ast.list(ast.atom('lambda'), ast.list(ast.atom('x')), ast.atom('x'));
        var constraints = Immutable.List();

        var result = infer.constraints(expression, constraints);

        result.type.isLambda.should.be.true();
        result.type.parameterTypes.size.should.equal(1);
        result.type.parameterTypes.get(0).isVariable.should.be.true();
        result.type.returnType.isVariable.should.be.true();
        result.type.returnType.name.should.equal(result.type.parameterTypes.get(0).name);
    });

    it('should return _2 and [(lambda (_1) _1) (lambda (integer) _2)] given (f 2) and [f (lambda (_1) _1)]', function () {
        var expression = ast.list(ast.atom('f'), ast.atom('2'));
        var type_1 = Type.variable('_1');
        var constraints = Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List.of(type_1), type_1)]
        );

        var result = infer.constraints(expression, constraints);

        result.type.isVariable.should.be.true();
        result.constraints.size.should.equal(1);
        var constraint = result.constraints.get(0);
        constraint[0].isLambda.should.be.true();
        constraint[0].parameterTypes.get(0).isVariable.should.be.true();
        constraint[0].returnType.isVariable.should.be.true();
        constraint[0].returnType.name.should.equal(constraint[0].parameterTypes.get(0).name);
        constraint[1].isLambda.should.be.true();
        constraint[1].parameterTypes.get(0).isConstant.should.be.true();
        constraint[1].parameterTypes.get(0).name.should.equal('integer');
        constraint[1].returnType.isVariable.should.be.true();
        constraint[1].returnType.name.should.equal(result.type.name);
    });

    it('should return _1 and [(lambda (_2) _2) (lambda (integer) _1)] given ((lambda (x) x) 2) and []', function () {
        var expression = ast.list(ast.list(ast.atom('lambda'), ast.list(ast.atom('x')), ast.atom('x')), ast.atom('2'));
        var constraints = Immutable.List();

        var result = infer.constraints(expression, constraints);

        result.type.isVariable.should.be.true();
        result.constraints.size.should.equal(1);
        var constraint = result.constraints.get(0);
        constraint[0].isLambda.should.be.true();
        constraint[0].parameterTypes.get(0).isVariable.should.be.true();
        constraint[0].returnType.isVariable.should.be.true();
        constraint[0].returnType.name.should.equal(constraint[0].parameterTypes.get(0).name);
        constraint[1].isLambda.should.be.true();
        constraint[1].parameterTypes.get(0).isConstant.should.be.true();
        constraint[1].parameterTypes.get(0).name.should.equal('integer');
        constraint[1].returnType.isVariable.should.be.true();
        constraint[1].returnType.name.should.equal(result.type.name);
    });

    it('should return _1 and [(lambda (_2 _3) _3) (lambda (integer integer) _1)] given ((lambda (x y) y) 1 2) and []', function () {
        var expression = ast.list(ast.list(ast.atom('lambda'), ast.list(ast.atom('x'), ast.atom('y')), ast.atom('y')), ast.atom('1'), ast.atom('2'));
        var constraints = Immutable.List();

        var result = infer.constraints(expression, constraints);

        result.type.isVariable.should.be.true();
        result.constraints.size.should.equal(1);
        var constraint = result.constraints.get(0);
        constraint[0].isLambda.should.be.true();
        constraint[0].parameterTypes.get(0).isVariable.should.be.true();
        constraint[0].parameterTypes.get(0).name.should.not.equal(constraint[0].parameterTypes.get(1).name);
        constraint[0].parameterTypes.get(1).isVariable.should.be.true();
        constraint[0].returnType.isVariable.should.be.true();
        constraint[0].returnType.name.should.equal(constraint[0].parameterTypes.get(1).name);
        constraint[1].isLambda.should.be.true();
        constraint[1].parameterTypes.get(0).isConstant.should.be.true();
        constraint[1].parameterTypes.get(0).name.should.equal('integer');
        constraint[1].parameterTypes.get(1).isConstant.should.be.true();
        constraint[1].parameterTypes.get(1).name.should.equal('integer');
        constraint[1].returnType.isVariable.should.be.true();
        constraint[1].returnType.name.should.equal(result.type.name);
    });
});
