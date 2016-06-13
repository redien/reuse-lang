
var Promise = require('promise');
require('should');

var evaluateExpression = function (expression) {
    return new Promise(function (resolve, reject) {
        try {
            var value = eval(expression);
            resolve(value);
        } catch (error) {
            reject(error);
        }
    });
};

module.exports = function () {
    this.Given(/^an expression "([^"]*)"$/, function (expression) {
        this.expression = expression;
    });

    this.When(/^I evaluate it$/, function () {
        this.result = evaluateExpression(this.expression);
    });

    this.Then(/^I should get "([^"]*)"$/, function (expected) {
        return this.result.should.eventually.equal(expected);
    });
};
