(comment

 reuse-lang - a pure functional lisp-like language for writing
 reusable algorithms in an extremely portable way.

 Written in 2015 by Jesper Oskarsson jesosk@gmail.com

 To the extent possible under law, the author(s) have dedicated all copyright
 and related and neighboring rights to this software to the public domain worldwide.
 This software is distributed without any warranty.

 You should have received a copy of the CC0 Public Domain Dedication along with this software.
 If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

)

(import stdlib/string.ru)

(export encode (lambda (name)
    (let (encode-with-accumulator (lambda (name name-length index encoded-name)
        (let (code-point (string:code-point-at-index name index))
        (if (< index name-length)
            (if (or (and (>= code-point 65) (<= code-point 90))
                    (and (>= code-point 97) (<= code-point 122)))
                (recur name name-length (+ index 1) (string:push encoded-name code-point))
                (recur name name-length (+ index 1) (string:concatenate (string:push encoded-name 95) (string:decimal-string-from-integer code-point))))
            encoded-name))))
    (encode-with-accumulator name (string:length name) 0 (string:new)))))
