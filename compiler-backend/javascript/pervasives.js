
function js_string_to_reuse(s) {
    var reuse_string = string_45empty();
    for (var i = 0; i < s.length; ++i) {
        reuse_string = string_45append(s.charAt(i))(reuse_string);
    }
    return reuse_string;
}

function js_list_to_reuse(l) {
    return l.reduceRight(function (a, b) { return list_45cons(b)(a); }, list_45empty());
}

function reuse_string_to_js(s) {
    return string_45foldl(a => b => b + String.fromCharCode(a))("")(s);
}

function reuse_boolean_to_js(b) {
    return b === CTrue;
}
