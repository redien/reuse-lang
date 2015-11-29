
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
var flags = require('flags');
var reuse = require('./lib/reuse');

flags.defineString('format', 'human', 'Format of output. Can be either human or json.');
flags.parse(process.argv.slice(3));

if (process.argv[2] === undefined) {
    console.error('\n');
    console.error('> No inputfile given.');
    console.error('');
    process.exit(1);
}

var program = fs.readFileSync(process.argv[2]).toString();

var moduleProvider = function (moduleName) {
    return fs.readFileSync(__dirname + '/' + moduleName).toString();
};

var result = reuse.translate(program, moduleProvider);

if (flags.get('format') === 'human') {
    if (reuse.isError(result)) {
        console.error('\n');
        console.error('> Encountered error: ' + reuse.errorType(result));
        console.error('>   at line ' + reuse.errorLine(result) + ' column ' + reuse.errorColumn(result));
        console.error('');
        process.exit(2);
    } else {
        process.stdout.write(reuse.value(result));
        process.stdout.write('\n');
    }

} else if (flags.get('format') === 'json') {
    if (reuse.isError(result)) {
        process.stdout.write(JSON.stringify({
            error: reuse.errorType(result),
            line: reuse.errorLine(result),
            column: reuse.errorColumn(result)
        }));
    } else {
        process.stdout.write(JSON.stringify({
            value: reuse.value(result)
        }));
    }

} else {
    console.error('\n');
    console.error('> Invalid format: ' + flags.get('format'));
    console.error('');
    process.exit(3);
}
