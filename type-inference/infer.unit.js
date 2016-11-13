
var Immutable = require('immutable');
var should = require('should');
var infer = require('./infer');

var ast = require('../parser/ast');
var Type = require('./type');

describe('Type inferer', function () {
    it('should return integer given ((lambda (x) x) 1) and []', function () {
        var expression = ast.list(ast.list(ast.atom('lambda'), ast.list(ast.atom('x')), ast.atom('x')), ast.atom('1'));
        var constraints = Immutable.List();

        var type = infer.type(expression, constraints);

        type.isConstant.should.be.true();
        type.name.should.equal('integer');
    });

    it('should return integer given (f 1) and [f (lambda (x) x)]', function () {
        var expression = ast.list(ast.atom('f'), ast.atom('1'));
        var constraints = Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List.of(Type.variable('x')), Type.variable('x'))]
        );

        var type = infer.type(expression, constraints);

        type.isConstant.should.be.true();
        type.name.should.equal('integer');
    });

    it('should return (lambda (a a a) a) given (lambda (x y z) (f x (g y z))) and [f (lambda (a a) a) g (lambda (a a) a)]', function () {
        var expression = ast.list(
            ast.atom('lambda'),
            ast.list(ast.atom('x'), ast.atom('y'), ast.atom('z')),
            ast.list(ast.atom('f'), ast.atom('x'), ast.list(ast.atom('g'), ast.atom('y'), ast.atom('z')))
        );
        var constraints = Immutable.List.of(
            [Type.variable('f'), Type.lambda(Immutable.List.of(Type.constant('a'), Type.constant('a')), Type.constant('a'))],
            [Type.variable('g'), Type.lambda(Immutable.List.of(Type.constant('a'), Type.constant('a')), Type.constant('a'))]
        );

        var type = infer.type(expression, constraints);

        type.isLambda.should.be.true();
        type.parameterTypes.size.should.equal(3);
        type.parameterTypes.get(0).isConstant.should.be.true();
        type.parameterTypes.get(0).name.should.equal('a');
        type.parameterTypes.get(1).isConstant.should.be.true();
        type.parameterTypes.get(1).name.should.equal('a');
        type.parameterTypes.get(2).isConstant.should.be.true();
        type.parameterTypes.get(2).name.should.equal('a');
        type.returnType.isConstant.should.be.true();
        type.returnType.name.should.equal('a');
    });
});
