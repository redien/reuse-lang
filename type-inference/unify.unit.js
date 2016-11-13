
var Immutable = require('immutable');
var should = require('should');
var infer = require('./unify');
var Type = require('./type');

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

        it('should return NOT_UNIFIED given [X a X b]', function () {
            var constraints = Immutable.List.of(
                [ Type.variable('X'), Type.constant('a') ],
                [ Type.variable('X'), Type.constant('b') ]
            );

            var result = infer.unify(constraints);

            result.should.equal(infer.NOT_UNIFIED);
        });

        it('should return NOT_UNIFIED given [X (lambda () a) X b]', function () {
            var constraints = Immutable.List.of(
                [ Type.variable('X'), Type.lambda(Immutable.List(), Type.constant('a')) ],
                [ Type.variable('X'), Type.constant('b') ]
            );

            var result = infer.unify(constraints);

            result.should.equal(infer.NOT_UNIFIED);
        });
    });
});
