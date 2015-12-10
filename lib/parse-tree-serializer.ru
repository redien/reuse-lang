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
(import ./lib/parse-tree.ru)

(define serialize-list (lambda (list child-index string)
    (if (< child-index (parse-tree:count list))
        (let (child (parse-tree:child list child-index))
        (let (serialized-child (parse-tree-serializer:serialize child))
        (recur
            list
            (+ child-index 1)
            (string:concatenate string (if (< child-index (- (parse-tree:count list) 1)) (string:push serialized-child 32) serialized-child)))))
        string)))

(export parse-tree-serializer:serialize (lambda (parse-tree)
    (if (parse-tree:list? parse-tree)
        (string:push (string:concatenate (string:push (string:new) 40) (serialize-list parse-tree 0 (string:new))) 41)
        (parse-tree:value parse-tree))))
