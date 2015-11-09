
(import stdlib/vector.ru)
(import stdlib/string.ru)

(export vectorFromString (lambda (string)
    (let (vector-from-string-with-accumulator (lambda (string index vector)
        (if (< index (string:length string))
            (self string (+ index 1) (vector:push vector (string:code-point-at-index string index)))
            vector)))
    (vector-from-string-with-accumulator string 0 (vector:new)))))
