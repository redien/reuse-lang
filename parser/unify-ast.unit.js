
var Immutable = require('immutable');
var should = require('should');
var ast = require('./ast');
var unifyAst = require('./unify-ast');
var variable = unifyAst.variable;

describe('unifyAst', function () {
    describe('delete', function () {
        it('should unify with {} given a and a', function () {
            var first = ast.atom('a');
            var second = ast.atom('a');

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(0);
        });

        it('should unify with {} given (a) and (a)', function () {
            var first = ast.list(ast.atom('a'));
            var second = ast.list(ast.atom('a'));

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(0);
        });

        it('should unify with {} given X and X', function () {
            var first = variable('X');
            var second = variable('X');

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(0);
        });
    });

    describe('decompose', function () {
        it('should unify with {X: b} given X and b', function () {
            var first = variable('X');
            var second = ast.atom('b');

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(1);
            ast.isAtom(output.get('X')).should.be.true();
            ast.atomValue(output.get('X')).should.equal('b');
        });

        it('should unify with {Y: a} given a and Y', function () {
            var first = ast.atom('a');
            var second = variable('Y');

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(1);
            ast.isAtom(output.get('Y')).should.be.true();
            ast.atomValue(output.get('Y')).should.equal('a');
        });

        it('should unify with {X: Y} given X and Y', function () {
            var first = variable('X');
            var second = variable('Y');

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(1);
            output.get('X').isVariable.should.be.true();
            output.get('X').name.should.equal('Y');
        });

        it('should unify with {Y: (b X)} given (a (b X)) and (a Y)', function () {
            var first = ast.list(ast.atom('a'), ast.list(ast.atom('b'), variable('X')));
            var second = ast.list(ast.atom('a'), variable('Y'));

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(1);
            ast.isList(output.get('Y')).should.be.true();
            ast.listSize(output.get('Y')).should.equal(2);
            ast.isAtom(ast.listChild(output.get('Y'), 0)).should.be.true();
            ast.atomValue(ast.listChild(output.get('Y'), 0)).should.equal('b');
            ast.listChild(output.get('Y'), 1).isVariable.should.be.true();
            ast.listChild(output.get('Y'), 1).name.should.equal('X');
        });

        it('should unify with {X: 1, Y: (b 1)} given (a (b X) X) and (a Y 1)', function () {
            var first = ast.list(ast.atom('a'), ast.list(ast.atom('b'), variable('X')), variable('X'));
            var second = ast.list(ast.atom('a'), variable('Y'), ast.atom('1'));

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(2);

            ast.isAtom(output.get('X')).should.be.true();
            ast.atomValue(output.get('X')).should.equal('1');

            ast.isList(output.get('Y')).should.be.true();
            ast.listSize(output.get('Y')).should.equal(2);
            ast.isAtom(ast.listChild(output.get('Y'), 0)).should.be.true();
            ast.atomValue(ast.listChild(output.get('Y'), 0)).should.equal('b');
            ast.isAtom(ast.listChild(output.get('Y'), 1)).should.be.true();
            ast.atomValue(ast.listChild(output.get('Y'), 1)).should.equal('1');
        });

        it('should unify with {X: a, Y: a} given (X Y) and (Y a)', function () {
            var first = ast.list(variable('X'), variable('Y'));
            var second = ast.list(variable('Y'), ast.atom('a'));

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(2);
            ast.isAtom(output.get('X')).should.be.true();
            ast.atomValue(output.get('X')).should.equal('a');
            ast.isAtom(output.get('Y')).should.be.true();
            ast.atomValue(output.get('Y')).should.equal('a');
        });

        it('should unify with {X: a, Y: a} given (a X) and (Y Y)', function () {
            var first = ast.list(ast.atom('a'), variable('X'));
            var second = ast.list(variable('Y'), variable('Y'));

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(2);
            ast.isAtom(output.get('X')).should.be.true();
            ast.atomValue(output.get('X')).should.equal('a');
            ast.isAtom(output.get('Y')).should.be.true();
            ast.atomValue(output.get('Y')).should.equal('a');
        });

        it('should unify with {X: b} given (X) and (b)', function () {
            var first = ast.list(variable('X'));
            var second = ast.list(ast.atom('b'));

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(1);
            ast.isAtom(output.get('X')).should.be.true();
            ast.atomValue(output.get('X')).should.equal('b');
        });

        it('should unify with {X: 1, Y: 2} given (X Y) and (1 2)', function () {
            var first = ast.list(variable('X'), variable('Y'));
            var second = ast.list(ast.atom('1'), ast.atom('2'));

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(2);
            ast.isAtom(output.get('X')).should.be.true();
            ast.atomValue(output.get('X')).should.equal('1');
            ast.isAtom(output.get('Y')).should.be.true();
            ast.atomValue(output.get('Y')).should.equal('2');
        });

        it('should unify with {X: 1, Y: 2} given (a 2) and (1 b)', function () {
            var first = ast.list(variable('X'), ast.atom('2'));
            var second = ast.list(ast.atom('1'), variable('Y'));

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(2);
            ast.isAtom(output.get('X')).should.be.true();
            ast.atomValue(output.get('X')).should.equal('1');
            ast.isAtom(output.get('Y')).should.be.true();
            ast.atomValue(output.get('Y')).should.equal('2');
        });

        it('should unify with {X: 1, Y: 3} given ((1 2) 3 ()) and ((X 2) Y ())', function () {
            var first = ast.list(ast.list(ast.atom('1'), ast.atom('2')), ast.atom('3'), ast.list());
            var second = ast.list(ast.list(variable('X'), ast.atom('2')), variable('Y'), ast.list());

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(2);
            ast.isAtom(output.get('X')).should.be.true();
            ast.atomValue(output.get('X')).should.equal('1');
            ast.isAtom(output.get('Y')).should.be.true();
            ast.atomValue(output.get('Y')).should.equal('3');
        });

        it('should unify with {X: b} given X:atom and b', function () {
            var first = variable('X', 'atom');
            var second = ast.atom('b');

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(1);
            ast.isAtom(output.get('X')).should.be.true();
            ast.atomValue(output.get('X')).should.equal('b');
        });

        it('should unify with {Y: a} given a and Y:atom', function () {
            var first = ast.atom('a');
            var second = variable('Y', 'atom');

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(1);
            ast.isAtom(output.get('Y')).should.be.true();
            ast.atomValue(output.get('Y')).should.equal('a');
        });

        it('should unify with {X: ()} given X:list and ()', function () {
            var first = variable('X', 'list');
            var second = ast.list();

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(1);
            ast.isList(output.get('X')).should.be.true();
            ast.listSize(output.get('X')).should.equal(0);
        });

        it('should unify with {X: ()} given () and X:list', function () {
            var first = ast.list();
            var second = variable('X', 'list');

            var output = unifyAst(first, second);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(1);
            ast.isList(output.get('X')).should.be.true();
            ast.listSize(output.get('X')).should.equal(0);
        });
    });

    describe('conflict', function () {
        it('should not unify given a and b', function () {
            var first = ast.atom('a');
            var second = ast.atom('b');

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });

        it('should not unify given a and ()', function () {
            var first = ast.atom('a');
            var second = ast.list();

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });

        it('should not unify given () and a', function () {
            var first = ast.list();
            var second = ast.atom('a');

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });

        it('should not unify given (a) and (a b)', function () {
            var first = ast.list(ast.atom('a'));
            var second = ast.list(ast.atom('a'), ast.atom('b'));

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });

        it('should not unify given (X X) and (1 2)', function () {
            var first = ast.list(variable('X'), variable('X'));
            var second = ast.list(ast.atom('1'), ast.atom('2'));

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });

        it('should not unify given X:atom and ()', function () {
            var first = variable('X', 'atom');
            var second = ast.list();

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });

        it('should not unify given () and X:atom', function () {
            var first = ast.list();
            var second = variable('X', 'atom');

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });

        it('should not unify given X:list and b', function () {
            var first = variable('X', 'list');
            var second = ast.atom('b');

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });

        it('should not unify given b and X:list', function () {
            var first = ast.atom('b');
            var second = variable('X', 'list');

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });

        it('should not unify given (a X) and (b Y)', function () {
            var first = ast.list(ast.atom('a'), variable('X'));
            var second = ast.list(ast.atom('b'), variable('Y'));

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });
    });

    describe('Occurs Check', function () {
        it('should not unify given X and (X)', function () {
            var first = variable('X');
            var second = ast.list(variable('X'));

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });

        it('should not unify given X and (b, X)', function () {
            var first = variable('X');
            var second = ast.list(ast.atom('b'), variable('X'));

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });

        it('should not unify given X and (b, (X))', function () {
            var first = variable('X');
            var second = ast.list(ast.atom('b'), ast.list(variable('X')));

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });

        it('should not unify given (X) and X', function () {
            var first = ast.list(variable('X'));
            var second = variable('X');

            var output = unifyAst(first, second);

            output.should.equal(unifyAst.NOT_UNIFIED);
        });

        it('should unify with {X: (X)} given X and (X) and occursCheck == false', function () {
            var first = variable('X');
            var second = ast.list(variable('X'));

            var output = unifyAst(first, second, false);

            output.should.be.an.instanceOf(Immutable.Map);
            output.size.should.equal(1);
            ast.isList(output.get('X')).should.be.true();
            ast.listSize(output.get('X')).should.equal(1);
            ast.listChild(output.get('X'), 0).isVariable.should.be.true();
            ast.listChild(output.get('X'), 0).name.should.equal('X');
        });
    });
});
