
var common = require('./common');

var programBuilder = function (translatedExpression) {
    return `
    #include <stdio.h>

    int max(int a, int b) { return a < b ? b : a; }
    int min(int a, int b) { return a > b ? b : a; }

    int main(int argc, char** argv) {
        int expression = ${translatedExpression};
        printf("%d", expression);
        return 0;
    }
    `;
};

var commandBuilder = function (sourcePath, executablePath) {
    return 'CC ' + sourcePath + ' -o ' + executablePath + ' && ' + executablePath;
};

var evaluateExpression = common.compileAndEvaluateExpression('.c', programBuilder, commandBuilder);

module.exports = common.stepDefinitions('c', evaluateExpression);
