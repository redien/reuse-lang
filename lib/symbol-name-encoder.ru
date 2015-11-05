
(import stdlib/string.ru)

(export encode (lambda (name)
    (let (encode-with-accumulator (lambda (name index encoded-name)
        (let (name-length (string:length name))
        (let (code-point (string:code-point-at-index name index))
        (if (< index name-length)
            (if (or (and (>= code-point 65) (<= code-point 90))
                    (and (>= code-point 97) (<= code-point 122)))
                (self name (+ index 1) (string:push encoded-name code-point))
                (self name (+ index 1) (string:concatenate (string:push encoded-name 95) (string:decimal-string-from-integer code-point))))
            encoded-name)))))
    (encode-with-accumulator name 0 (string:new)))))
