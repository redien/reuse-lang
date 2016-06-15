
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

module.exports = common.stepDefinitions('javascript', '.js', programBuilder, commandBuilder);
