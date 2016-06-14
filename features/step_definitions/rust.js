
var common = require('./common');

var programBuilder = function (translatedExpression) {
    return `
    fn main() {
        print!("{}", (${translatedExpression}));
    }
    `;
};

var commandBuilder = function (sourcePath, executablePath) {
    return 'rustc ' + sourcePath + ' -o ' + executablePath + ' && ' + executablePath;
};

var evaluateExpression = common.compileAndEvaluateExpression('.rs', programBuilder, commandBuilder);

module.exports = common.stepDefinitions('rust', evaluateExpression);
