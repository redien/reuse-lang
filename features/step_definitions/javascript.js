
var common = require('./common');

var programBuilder = function (translatedExpression) {
    return `
    var max = Math.max;
    var min = Math.min;
    process.stdout.write((${translatedExpression}).toString());
    `;
};

var commandBuilder = function (sourcePath, executablePath) {
    return 'node ' + sourcePath;
};

var evaluateExpression = common.compileAndEvaluateExpression('.js', programBuilder, commandBuilder);

module.exports = common.stepDefinitions('javascript', evaluateExpression);
