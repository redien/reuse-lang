#!/usr/bin/env node

var fs = require('fs');
var child_process = require('child_process');
var path = require('path');

var parser = require('./spec-parser.js');
var match = parser.match;
var $ = parser.$;

var specPath = process.argv[2];
var command = process.argv[3];

var passing = 0, failing = 0, total = 0;

function testSpecFile(filePath) {
    var input = fs.readFileSync(filePath);

    var createTestCase = type => (context, expression, expected) => ({
        type,
        context: parser.reuse_string_to_js(context),
        expression: parser.reuse_string_to_js(expression),
        expected: parser.reuse_string_to_js(expected)
    });

    var testCases = parser.reuse_list_to_js(parser.list_map(testCase =>
        match(testCase, [
            [parser.ExpectSuccess, $, $, $], createTestCase('success'),
            [parser.ExpectFailure, $, $, $], createTestCase('failure'),
            [parser.Comment, $], comment => ({ type: 'comment', comment: parser.reuse_string_to_js(comment) })
        ])
    , parser.parse_spec(input)));

    testCases.forEach(testCase => {
        var result = child_process.spawnSync(command, [testCase.context, testCase.expression]);
        var stderr = result.stderr.toString('utf8');
        var stdout = result.stdout.toString('utf8');

        if (testCase.type === 'success') {
            if (result.status !== 0) {
                console.log("not ok " + total + " - program returned non-zero status code");
                console.log("---");
                console.log("  expression:  '" + testCase.expression + "'");
                console.log("  program:     '" + testCase.context + "'");
                console.log("  status-code: '" + result.status + "'");
                console.log("  error:");
                console.log(stderr);
                console.log("...");
                failing++;
            } else if (stdout === testCase.expected) {
                console.log("ok " + total + " - " + testCase.expression + " = " + stdout);
                passing++;
            } else {
                console.log("not ok " + total + " - expected '" + testCase.expected + "' but got '" + stdout + "'");
                console.log("---");
                console.log("  expression: '" + testCase.expression + "'");
                console.log("  program:    '" + testCase.context + "'");
                console.log("  expected:   '" + testCase.expected + "'");
                console.log("  actual:     '" + stdout + "'");
                console.log("...");
                failing++;
            }
        } else if (testCase.type === 'failure') {
            if (result.status === 0) {
                console.log("not ok " + total + " - expected program to return a non-zero status code");
                console.log("---");
                console.log("  expression:  '" + testCase.expression + "'");
                console.log("  program:     '" + testCase.context + "'");
                console.log("  actual:      '" + stdout + "'");
                console.log("...");
                failing++;
            } else if (stderr.indexOf(testCase.expected) !== -1) {
                console.log("ok " + total + " - Error contains '" + testCase.expected + "'");
                passing++;
            } else {
                console.log("not ok " + total + " - expected '" + stderr + "' to contain '" + testCase.expected + "'");
                console.log("---");
                console.log("  expression: '" + testCase.expression + "'");
                console.log("  program:    '" + testCase.context + "'");
                console.log("  expected:   '" + testCase.expected + "'");
                console.log("  actual:     '" + stderr + "'");
                console.log("...");
                failing++;
            }
        } else {
            console.log('# ' + testCase.comment);
        }

        total++;
    });
}

console.log('TAP version 13');

if (fs.statSync(specPath).isDirectory) {
    fs.readdirSync(specPath).forEach(filename => {
        if (filename.indexOf('.spec') === filename.length - 5) {
            testSpecFile(path.join(specPath, filename));
        }
    });
} else {
    testSpecFile(specPath);
}

console.log('1..' + total);

console.log('# tests ' + total);
console.log('# pass ' + passing);
console.log('# fail ' + failing);

if (failing != 0) {
    process.exit(1);
}
