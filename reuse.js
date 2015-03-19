
// reuse-lang - a pure functional lisp-like language for writing
// reusable business-logic in an extremely portable way.
//
// Written in 2015 by Jesper Oskarsson jesosk@gmail.com
//
// To the extent possible under law, the author(s) have dedicated all copyright
// and related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

var parser = require('./lib/parser');
var interpreter = require('./lib/interpreter');
var validator = require('./lib/validator');

process.stdin.setEncoding('utf8');

var program = '';
process.stdin.on('readable', function () {
    var chunk = process.stdin.read();
    if (chunk !== null) {
        program += chunk.toString();
    }
});
process.stdin.on('end', function () {
    parser.parse(program, function (error, parsedProgram) {
        if (error) { throw error; }
        validator.validate(parsedProgram, function (error) {
            if (error) { throw error; }
            interpreter.evaluate(parsedProgram, function (error, value) {
                if (error) { throw error; }
                
                if (value === null) {
                    value = 'null';
                }
                
                process.stdout.write(value.toString());
                process.stdout.write('\n');
            });
        });
    });
});
