
var common = require('./common');

var Promise = require('promise');

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

module.exports = common.stepDefinitions('javascript', evaluateExpression);
