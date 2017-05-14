#!/bin/bash

script_path=$(dirname "$0")

$script_path/compile-library.sh $1 $2

cat >> $2 << EOM
process.stdin.resume();

var input = Buffer.from([]);

function unicodePointsFromString(str) {
    var array = [];

    for (var i = 0; i < str.length; ++i) {
        var point = str.codePointAt(i);
        if (point !== undefined) {
            array.push(point);
        }
    }

    return array;
}

function stringToList(str) {
    var list = 0;
    var points = unicodePointsFromString(str);

    for (var i = points.length - 1; i >= 0; --i) {
        var point = points[i];
        if (point !== undefined) {
            list = [point, list];
        }
    }

    return list;
}

function listToString(list) {
    var str = '';

    while (list !== 0) {
        str += String.fromCodePoint(list[0]);
        list = list[1];
    }

    return str;
}

process.stdin.on('data', function (chunk) {
    input = Buffer.concat([input, chunk]);
});

process.stdin.on('end', function () {
    var inputList = stringToList(input.toString('utf8'));
    var outputList = module.exports.main(inputList);
    process.stdout.write(Buffer.from(listToString(outputList), 'utf8'));
});
EOM
