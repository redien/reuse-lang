
// reuse-lang - a pure functional lisp-like language for writing
// reusable algorithms in an extremely portable way.
//
// Written in 2015 by Jesper Oskarsson jesosk@gmail.com
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

var fs = require('fs');
var child_process = require('child_process');

var generateName = function (base, fileEnding) {
    return __dirname + '/' + base + Math.random() + fileEnding;
};

var writeTempFile = function (base, fileEnding, contents) {
    var fileName = generateName(base, fileEnding);
    fs.writeFileSync(fileName, contents);
    return fileName;
};

var translateProgramString = function (program) {
    var inputFile = writeTempFile('input-file', '.ru', program);
    try {
        var json = child_process.execSync('node reuse.js ' + inputFile + ' --format=json', {
            stdio: [null, null],
            cwd: __dirname + '/../../',
            timeout: 30000 // If process takes more than 30 seconds
                           // something is wrong.
        });

        try {
            fs.unlinkSync(inputFile);
        } catch (error) {}

        var result = JSON.parse(json);
        if (result.error) {
            throw result;
        }

        return result.value;

    } catch (error) {
        try {
            fs.unlinkSync(inputFile);
        } catch (error) {}
        throw error;
    }
};

var evaluate = function (expression, translation) {
    // Make sure we don't get the cached module when we require.
    var testModuleName = writeTempFile('test-module', '.js', translation);

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

var evaluateExpressionWithProgram = function (expression, program) {
    var translation = translateProgramString(program);
    return evaluate(expression, translation);
};
module.exports.evaluateExpressionWithProgram = evaluateExpressionWithProgram;
