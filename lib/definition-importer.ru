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

(import stdlib/list.ru)
(import stdlib/string.ru)

(define parse-tree:list-kind (string:push (string:push (string:push (string:push (string:new) 108) 105) 115) 116))
(define parse-tree:atom-kind (string:push (string:push (string:push (string:push (string:new) 97) 116) 111) 109))

(define parse-tree:atom (lambda (value line column)
    (cons 1 (cons value (cons line (cons column nil))))))

(define parse-tree:list (lambda ()
    (cons 0 nil)))

(define parse-tree:kind (lambda (expression)
    (if (== (first expression) 0)
        parse-tree:list-kind
        parse-tree:atom-kind)))

(define parse-tree:atom? (lambda (expression)
    (== (first expression) 1)))

(define parse-tree:list? (lambda (expression)
    (== (first expression) 0)))

(define parse-tree:value (lambda (expression)
    (first (rest expression))))

(define parse-tree:line (lambda (expression)
    (first (rest (rest expression)))))

(define parse-tree:column (lambda (expression)
    (first (rest (rest (rest expression))))))

(define parse-tree:child (lambda (expression index)
    (let (list (rest expression))
    (let (count (list:count list))
    (let (item-at-position (lambda (list index target-index)
        (if (and (< index count) (< index target-index))
            (self (rest list) (+ index 1))
            (first list))))
    (item-at-position list 0 index))))))

(define parse-tree:count (lambda (expression)
    (let (list (rest expression))
    (list:count list))))

(define parse-tree:push (lambda (expression child)
    (let (list (rest expression))
    (let (push-back (lambda (list item)
        (list:concatenate list (cons item nil))))
    (cons 0 (push-back list child))))))

(define export-value (string:push (string:push (string:push (string:push (string:push (string:push (string:new) 101) 120) 112) 111) 114) 116))
(define import-value (string:push (string:push (string:push (string:push (string:push (string:push (string:new) 105) 109) 112) 111) 114) 116))

(define new-define-from-import-atom (lambda (line column) (parse-tree:atom (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:new) 100) 101) 102) 105) 110) 101) 45) 102) 114) 111) 109) 45) 105) 109) 112) 111) 114) 116) line column)))

(export import (lambda (program module-loader)
    (let (convert-module (lambda (state new-program)
        (if (nil? state)
            new-program

            (let (program (first (first state)))
            (let (statement-index (first (rest (first state))))
            (let (module-name (first (rest (rest (first state)))))
            (let (redefine-exports (rest (rest (rest (first state)))))

            (let (state-for-next-statement (lambda ()
                (if (< statement-index (parse-tree:count program))
                    (cons (cons program (cons (+ statement-index 1) (cons module-name redefine-exports))) (rest state))
                    (rest state))))

            (let (state-with-imported-module (lambda (module-name)
                (cons (cons (module-loader module-name) (cons 0 (cons module-name true))) (state-for-next-statement))))

            (let (statement (parse-tree:child program statement-index))
            (let (form-name (parse-tree:value (parse-tree:child statement 0)))
            (let (statement
                (if (and redefine-exports (string:equal? export-value form-name))
                    (parse-tree:push (parse-tree:push (parse-tree:push (parse-tree:push (parse-tree:list)
                        (new-define-from-import-atom 0 0))
                        (parse-tree:child statement 1))
                        (parse-tree:child statement 2))
                        (parse-tree:atom module-name 0 0))
                    statement))

            (let (new-program
                (if (or (string:equal? import-value form-name) (>= statement-index (parse-tree:count program)))
                    new-program
                    (parse-tree:push new-program statement)))

            (let (next-state
                (if (string:equal? import-value form-name)
                    (state-with-imported-module (parse-tree:value (parse-tree:child statement 1)))
                    (state-for-next-statement)))

            (self next-state new-program)))))))))))))))
    (convert-module (cons (cons program (cons 0 (cons (string:new) false))) nil) (parse-tree:list)))))
