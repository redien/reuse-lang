
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

var parser = require('../lib/parser');
var interpreter = require('../lib/interpreter');

exports.evaluate = function (program, done) {
    parser.parse(program, function (error, parsedProgram) {
        if (error) { return done(error); }
        interpreter.evaluate(parsedProgram, function (error, value) {
            if (error) { return done(error); }
            return done(error, value);
        });
    });
};