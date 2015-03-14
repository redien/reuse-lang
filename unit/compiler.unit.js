
var should = require('should');
var compiler = require('../lib/compiler');

describe('compiler', function () {
    describe('compileParsedProgram', function () {
        it('should compile null into an empty program', function () {
            var parsedProgram = null;
            var compiledProgram = compiler.compileParsedProgram(parsedProgram);

            compiledProgram.should.equal('');
        });
    });
});
