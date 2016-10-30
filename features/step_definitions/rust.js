
var common = require('./common');

var programBuilder = function (translatedExpression) {
    return `
    use std::cmp::max as max;
    use std::cmp::min as min;

    ${translatedExpression}

    fn main() {
        print!("{}", expression());
    }
    `;
};

var commandBuilder = function (sourcePath, executablePath) {
    return 'rustc ' + sourcePath + ' -o ' + executablePath + ' && ' + executablePath;
};

module.exports = common.stepDefinitions('rust', '.rs', programBuilder, commandBuilder);
