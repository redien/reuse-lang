
var compiler = require('./compiler');

process.stdin.setEncoding('utf8');

var program = '';
process.stdin.on('readable', function () {
    var chunk = process.stdin.read();
    if (chunk !== null) {
        program += chunk.toString();
    }
});
process.stdin.on('end', function () {
    var compiledProgram = compiler.compile(program);
    process.stdout.write(compiledProgram);
});
