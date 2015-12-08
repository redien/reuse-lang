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
(import stdlib/list.ru)

(export parse-tree:list-kind (string:push (string:push (string:push (string:push (string:new) 108) 105) 115) 116))
(export parse-tree:atom-kind (string:push (string:push (string:push (string:push (string:new) 97) 116) 111) 109))

(export parse-tree:atom (lambda (value line column)
    (cons 1 (cons value (cons line (cons column nil))))))

(export parse-tree:list (lambda ()
    (cons 0 nil)))

(export parse-tree:kind (lambda (expression)
    (if (== (first expression) 0)
        parse-tree:list-kind
        parse-tree:atom-kind)))

(export parse-tree:atom? (lambda (expression)
    (== (first expression) 1)))

(export parse-tree:list? (lambda (expression)
    (== (first expression) 0)))

(export parse-tree:value (lambda (expression)
    (first (rest expression))))

(export parse-tree:line (lambda (expression)
    (first (rest (rest expression)))))

(export parse-tree:column (lambda (expression)
    (first (rest (rest (rest expression))))))

(export parse-tree:child (lambda (expression index)
    (let (list (rest expression))
    (let (count (list:count list))
    (let (item-at-position (lambda (list index target-index)
        (if (and (< index count) (< index target-index))
            (recur (rest list) (+ index 1))
            (first list))))
    (item-at-position list 0 index))))))

(export parse-tree:count (lambda (expression)
    (let (list (rest expression))
    (list:count list))))

(export parse-tree:push (lambda (expression child)
    (let (list (rest expression))
    (let (push-back (lambda (list item)
        (list:concatenate list (cons item nil))))
    (cons 0 (push-back list child))))))

(define transform-list (lambda (list child-index new-list should-replace? replace)
    (if (< child-index (parse-tree:count list))
        (recur list (+ child-index 1) (parse-tree:push new-list (parse-tree:transform (parse-tree:child list child-index) should-replace? replace)) should-replace? replace)
        new-list)))

(export parse-tree:transform (lambda (parse-tree should-replace? replace)
    (if (should-replace? parse-tree)
        (replace parse-tree)
        (if (parse-tree:list? parse-tree)
            (transform-list parse-tree 0 (parse-tree:list) should-replace? replace)
            parse-tree))))
