
var Promise = require('promise');
var reuse = require('../../module/reuse');
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
        this.expression = reuse.translate('javascript', expression);
    });

    this.When(/^I evaluate it$/, function () {
        this.result = evaluateExpression(this.expression);
    });

    this.Then(/^I should get "([^"]*)"$/, function (expected) {
        return this.result.then(function (result) {
            result.toString().should.equal(expected);
        });
    });
};
