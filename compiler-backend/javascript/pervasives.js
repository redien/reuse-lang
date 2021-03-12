
function js_string_to_reuse(s) {
    var reuse_string = string_empty();
    for (var i = 0; i < s.length; ++i) {
        reuse_string = string_append(s.charAt(i))(reuse_string);
    }
    return reuse_string;
}

function js_list_to_reuse(l) {
    return l.reduceRight(function (a, b) { return list_cons(b)(a); }, list_empty());
}

function reuse_string_to_js(s) {
    return string_foldl(a => b => b + String.fromCharCode(a))("")(s);
}

function reuse_boolean_to_js(b) {
    return b === True;
}
