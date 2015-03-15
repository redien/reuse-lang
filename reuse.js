
var parser = require('./lib/parser');
var interpreter = require('./lib/interpreter');

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
        interpreter.evaluate(parsedProgram, function (error, value) {
            if (error) { throw error; }
            process.stdout.write('\nOutput:\n');
            process.stdout.write(value.toString());
            process.stdout.write('\n');
        });
    });
});
