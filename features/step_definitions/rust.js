
var common = require('./common');

var programBuilder = function (translatedExpression) {
    return `
    use std::cmp::max as max;
    use std::cmp::min as min;

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
