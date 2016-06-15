
var reuse = require('../../module/reuse');

var Promise = require('promise');
var exec = require('child_process').exec;
var temp = require('temp').track();
var fs = require('fs');
require('should');

module.exports.stepDefinitions = function (language, suffix, programBuilder, commandBuilder) {
    var evaluateExpression = module.exports.compileAndEvaluateExpression(suffix, programBuilder, commandBuilder);

    return function () {
        this.Given(/^an expression "([^"]*)"$/, function (expression) {
            var result = reuse.translate(language, expression);
            this.translationError = result.error;
            if (result.error) {
                this.errorColumn = result.error.column;
                this.errorLine = result.error.line;
            }
            this.expression = result.source;
        });

        this.When(/^I evaluate it$/, function () {
            if (!this.translationError) {
                this.result = evaluateExpression(this.expression);
            }
        });

        this.Then(/^I should get "([^"]*)"$/, function (expected) {
            return this.result.then(function (result) {
                result.toString().should.equal(expected);
            });
        });

        this.Then(/^I should get a translation error "([^"]*)"$/, function (expected) {
            this.translationError.should.be.instanceOf(Error);
            this.translationError.message.should.equal(expected);
        });

        this.Then(/^the error column should say (\d+)$/, function (expected) {
            this.errorColumn.should.equal(parseInt(expected, 10));
        });

        this.Then(/^the error line should say (\d+)$/, function (expected) {
            this.errorLine.should.equal(parseInt(expected, 10));
        });
    };
};

module.exports.compileAndEvaluateExpression = function (suffix, programBuilder, commandBuilder) {
    return function (expression) {
        return new Promise(function (resolve, reject) {
            try {
                var program = programBuilder(expression);
                var sourcePath = temp.path({suffix: suffix});
                var executablePath = temp.path();

                fs.writeFileSync(sourcePath, program);

                exec(commandBuilder(sourcePath, executablePath), function (error, stdout) {
                    if (error) return reject(error);
                    resolve(stdout);
                });

            } catch (error) {
                reject(error);
            }
        });
    };
};
