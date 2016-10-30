
var common = require('./common');

var programBuilder = function (translatedExpression) {
    return `
    var max = Math.max;
    var min = Math.min;

    ${translatedExpression}

    process.stdout.write(expression.toString());
    `;
};

var commandBuilder = function (sourcePath, executablePath) {
    return 'node ' + sourcePath;
};

module.exports = common.stepDefinitions('javascript', '.js', programBuilder, commandBuilder);
