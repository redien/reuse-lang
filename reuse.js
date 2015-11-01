
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
var reuse = require('./lib/reuse');
var parser = require('./lib/parser');

var program = fs.readFileSync(process.argv[2]).toString();

var result = reuse.translate(program, function (moduleName) {
    var moduleString = fs.readFileSync(__dirname + '/' + moduleName).toString();
    return parser.value(parser.parse(moduleString));
});

if (result.error) {
    console.error('\n');
    console.error('> Encountered error: ' + result.error.message);
    console.error('>   at line ' + result.error.line + ' column ' + result.error.column);
    console.error('');
} else {
    process.stdout.write(result.value.toString());
    process.stdout.write('\n');
}
