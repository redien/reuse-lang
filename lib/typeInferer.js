
exports.infer = function infer(parsedProgram) {
    if (parsedProgram.kind === 'list') {
        if (parsedProgram.elements.length === 0) {
            return {
                type: '()',
                kind: 'list',
                elements: parsedProgram.elements
            };
        } else {
            var first = parsedProgram.elements[0];
            
            if (first.kind === 'list') {
                var expression = infer(first.elements[2]);
                return {
                    type: expression.type,
                    kind: 'list',
                    elements: [
                        first
                    ]
                };
            }
        }
    } else {
        if (parsedProgram.value.match(/^-?\d+$/)) {
            return {
                type: 'int32',
                kind: 'atom',
                value: parsedProgram.value
            };
        }
    }
};
