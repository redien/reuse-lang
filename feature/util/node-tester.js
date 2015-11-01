
var fs = require('fs');
var reuse = require(__dirname + '/../../lib/reuse');
var parser = require(__dirname + '/../../lib/parser')

var generateTestModuleName = function () {
    // Make sure we don't get the cached module when we require.
    return __dirname + '/test-module' + Math.random() + '.js';
};
module.exports.generateTestModuleName = generateTestModuleName;

var evaluateExpressionWithProgram = function (expression, program) {
    var testModuleName = generateTestModuleName();

    var translation = reuse.translate(program, function (moduleName) {
        var moduleString = fs.readFileSync(__dirname + '/../../' + moduleName).toString();
        return parser.value(parser.parse(moduleString));
    });

    if (translation.error) {
        throw translation;
    }

    fs.writeFileSync(testModuleName, translation.value);

    try {
        var module = require(testModuleName);
        var result = eval(expression);
        fs.unlinkSync(testModuleName);
        return result;

    } catch (exception) {
        fs.unlinkSync(testModuleName);
        throw exception;
    }
};
module.exports.evaluateExpressionWithProgram = evaluateExpressionWithProgram;
