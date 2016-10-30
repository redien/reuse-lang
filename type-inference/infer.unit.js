
var Immutable = require('immutable');
var should = require('should');
var infer = require('./infer');

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

describe('Type unification', function () {
    var find_variable = function (substitutions, name) {
        for (var index = 0; index < substitutions.size; ++index) {
            var subsitution = substitutions.get(index);
            if (subsitution[0].name === name) {
                return subsitution[1];
            }
        }

        throw new Error('No variable ' + name);
    };

    var variable_should_equal_constant = function (substitutions, name, constantName) {
        var constant = find_variable(substitutions, name);
        constant.isConstant.should.be.true();
        constant.name.should.equal(constantName);
    };

    var variable_should_equal_variable = function (substitutions, name, variableName) {
        var variable = find_variable(substitutions, name);
        variable.isVariable.should.be.true();
        variable.name.should.equal(variableName);
    };

    it('should return [] given [X X]', function () {
        var constraints = Immutable.List.of(
            [Type.variable('X'), Type.variable('X')]
        );

        var result = infer.unify(constraints);

        result.size.should.equal(0);
    });

    it('should return [] given [a a]', function () {
        var constraints = Immutable.List.of(
            [Type.constant('a'), Type.constant('a')]
        );

        var result = infer.unify(constraints);

        result.size.should.equal(0);
    });

    it('should return [] given [(lambda (X) a) (lambda (X) a)]', function () {
        var constraints = Immutable.List.of(
            [
                Type.lambda(Immutable.List.of(Type.variable('X')), Type.constant('a')),
                Type.lambda(Immutable.List.of(Type.variable('X')), Type.constant('a'))
            ]
        );

        var result = infer.unify(constraints);

        result.size.should.equal(0);
    });

    it('should return [X integer] given [X integer]', function () {
        var constraints = Immutable.List.of(
            [Type.variable('X'), Type.constant('integer')]
        );

        var result = infer.unify(constraints);

        result.size.should.equal(1);
        variable_should_equal_constant(result, 'X', 'integer');
    });

    it('should return [X integer] given [integer X]', function () {
        var constraints = Immutable.List.of(
            [Type.constant('integer'), Type.variable('X')]
        );

        var result = infer.unify(constraints);

        result.size.should.equal(1);
        variable_should_equal_constant(result, 'X', 'integer');
    });

    it('should return [X Y] given [X Y]', function () {
        var constraints = Immutable.List.of(
            [Type.variable('X'), Type.variable('Y')]
        );

        var result = infer.unify(constraints);

        result.size.should.equal(1);
        variable_should_equal_variable(result, 'X', 'Y');
    });

    it('should return [X V Y W Z Q] given [(lambda (X Y) Z) (lambda (V W) Q)]', function () {
        var constraints = Immutable.List.of(
            [
                Type.lambda(Immutable.List.of(Type.variable('X'), Type.variable('Y')), Type.variable('Z')),
                Type.lambda(Immutable.List.of(Type.variable('V'), Type.variable('W')), Type.variable('Q'))
            ]
        );

        var result = infer.unify(constraints);

        result.size.should.equal(3);
        variable_should_equal_variable(result, 'X', 'V');
        variable_should_equal_variable(result, 'Y', 'W');
        variable_should_equal_variable(result, 'Z', 'Q');
    });

    it('should return [Z b Y a X (lambda (a) b)] given [Z b Y a X (lambda (Y) Z)]', function () {
        var constraints = Immutable.List.of(
            [Type.variable('Z'), Type.constant('b')],
            [Type.variable('Y'), Type.constant('a')],
            [Type.variable('X'), Type.lambda(Immutable.List.of(Type.variable('Y')), Type.variable('Z'))]
        );

        var result = infer.unify(constraints);

        result.size.should.equal(3);

        variable_should_equal_constant(result, 'Z', 'b');
        variable_should_equal_constant(result, 'Y', 'a');

        result.get(2)[0].isVariable.should.be.true();
        result.get(2)[0].name.should.equal('X');
        var type = result.get(2)[1];
        type.isLambda.should.be.true();
        type.parameterTypes.get(0).isConstant.should.be.true();
        type.parameterTypes.get(0).name.should.equal('a');
        type.returnType.isConstant.should.be.true();
        type.returnType.name.should.equal('b');
    });

    it('should return [X a Y a] given [(lambda (X) X) (lambda (a) Y)]', function () {
        var constraints = Immutable.List.of(
            [
                Type.lambda(Immutable.List.of(Type.variable('X')), Type.variable('X')),
                Type.lambda(Immutable.List.of(Type.constant('a')), Type.variable('Y'))
            ]
        );

        var result = infer.unify(constraints);

        result.size.should.equal(2);
        variable_should_equal_constant(result, 'X', 'a');
        variable_should_equal_constant(result, 'Y', 'a');
    });

    describe('Errors', function () {
        it('should return NOT_UNIFIED given [a b]', function () {
            var constraints = Immutable.List.of(
                [
                    Type.constant('a'),
                    Type.constant('b')
                ]
            );

            var result = infer.unify(constraints);

            result.should.equal(infer.NOT_UNIFIED);
        });
    });
});

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
