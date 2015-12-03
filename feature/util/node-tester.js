
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

var translateProgramString = function (program, callback) {
    var inputFile = writeTempFile('input-file', '.ru', program);

    child_process.exec('node reuse.js ' + inputFile + ' --format=json', {
        stdio: [null, null],
        cwd: __dirname + '/../../',
        timeout: 30000 // If process takes more than 30 seconds
                       // something is wrong.
    }, function (error, json) {
        try {
            fs.unlinkSync(inputFile);
        } catch (error) {}

        if (error) {
            return callback(error);
        }

        return callback(null, JSON.parse(json));
    });
};

var evaluate = function (expression, translation, callback) {
    // Make sure we don't get the cached module when we require.
    var testModuleName = writeTempFile('test-module', '.js', translation);

    try {
        var module = require(testModuleName);
        var result = eval(expression);
        fs.unlinkSync(testModuleName);

        return callback(null, result);

    } catch (error) {
        try {
            fs.unlinkSync(testModuleName);
        } catch (error) {}

        return callback(error);
    }
};

var evaluateExpressionWithProgram = function (expression, program, callback) {
    var translation = translateProgramString(program, function (error, translation) {
        if (error) {
            return callback(error);
        }

        if (translation.error) {
            return callback(translation);
        }

        return evaluate(expression, translation.value, function (error, result) {
            if (error) {
                return callback(error);
            }

            return callback(null, result);
        });
    });
};
module.exports.evaluateExpressionWithProgram = evaluateExpressionWithProgram;
