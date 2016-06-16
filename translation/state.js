
var Immutable = require('immutable');

var state = module.exports;

state.new = function (expression, definitions) {
    return Immutable.Map.of('expression', expression, 'definitions', definitions);
};

state.expression = function (state) {
    return state.get('expression');
};

state.definitions = function (state) {
    return state.get('definitions');
};
