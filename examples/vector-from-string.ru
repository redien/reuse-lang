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

(import stdlib/vector.ru)
(import stdlib/string.ru)

(export vectorFromString (lambda (string)
    (let (vector-from-string-with-accumulator (lambda (string index vector)
        (if (< index (string:length string))
            (recur string (+ index 1) (vector:push vector (string:code-point-at-index string index)))
            vector)))
    (vector-from-string-with-accumulator string 0 (vector:new)))))

(export stringFromVector (lambda (vector)
    (let (string-from-vector-with-accumulator (lambda (vector index string)
        (if (< index (vector:length vector))
            (recur vector (+ index 1) (string:push string (vector:element-at-index vector index)))
            string)))
    (string-from-vector-with-accumulator vector 0 (string:new)))))
