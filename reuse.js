
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

var program = fs.readFileSync(process.argv[2]).toString();

var result = reuse.translate(program, reuse.moduleProvider);

if (result.error) {
    console.error('\n');
    console.error('> Encountered error: ' + result.error);
    console.error('>   at line ' + result.line + ' column ' + result.column);
    console.error('');
} else {
    process.stdout.write(result.value);
    process.stdout.write('\n');
}
