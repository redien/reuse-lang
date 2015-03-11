
var should = require('should');
var compiler = require('../lib/compiler');

describe('compiler', function () {
    describe('compile', function () {
        it('should compile "" into an empty program', function () {
            var program = "";
            var compiledProgram = compiler.compile(program);

            compiledProgram.should.equal('');
        });
    });
});
