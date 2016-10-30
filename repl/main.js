
var Readline = require('readline');
var Reuse = require('../module/reuse');

var readline = Readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

readline.setPrompt('reuse> ');
readline.prompt();

readline.on('line', function (expression) {
    try {
        var result = Reuse.translate('javascript', expression);
        if (result.error) {
            console.error(result.error);
        } else {
            console.log(result.source);
            eval(`
    var max = Math.max;
    var min = Math.min;

    ${result.source}

    console.log('Result: ' + expression.toString());
`);
        }
    } catch (error) {
        console.error(error);
    }

    readline.prompt();
});

readline.on('SIGINT', function() {
    process.exit();
});
