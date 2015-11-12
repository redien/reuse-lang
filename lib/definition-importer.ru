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
(import ./lib/parse-tree.ru)

(define export-value (string:push (string:push (string:push (string:push (string:push (string:push (string:new) 101) 120) 112) 111) 114) 116))
(define import-value (string:push (string:push (string:push (string:push (string:push (string:push (string:new) 105) 109) 112) 111) 114) 116))

(define new-define-from-import-atom (lambda (line column) (parse-tree:atom (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:new) 100) 101) 102) 105) 110) 101) 45) 102) 114) 111) 109) 45) 105) 109) 112) 111) 114) 116) line column)))

(define module-list-contains? (lambda (module-list module-name)
    (if (nil? module-list)
        false
        (if (string:equal? module-name (first module-list))
            true
            (self (rest module-list) module-name)))))

(define make-state (lambda (program statement-index module-name redefine-exports)
    (cons program
    (cons statement-index
    (cons module-name
          redefine-exports)))))

(define append-state (lambda (state-list state)
    (cons state state-list)))

(export import (lambda (program module-loader)
    (let (convert-module (lambda (state new-program imported-modules)
        (if (nil? state)
            new-program

            (let (program (first (first state)))
            (let (statement-index (first (rest (first state))))
            (let (module-name (first (rest (rest (first state)))))
            (let (redefine-exports (rest (rest (rest (first state)))))

            (let (state-for-next-statement (lambda ()
                (if (< statement-index (parse-tree:count program))
                    (append-state
                        (rest state)
                        (make-state
                            program
                            (+ statement-index 1)
                            module-name
                            redefine-exports))
                    (rest state))))

            (let (state-with-imported-module (lambda (module-name)
                (append-state
                    (state-for-next-statement)
                    (make-state
                        (module-loader module-name)
                        0
                        module-name
                        true))))

            (let (statement (parse-tree:child program statement-index))
            (let (form-name (parse-tree:value (parse-tree:child statement 0)))
            (let (statement
                (if (and
                        redefine-exports
                        (string:equal? export-value form-name))
                    (parse-tree:push (parse-tree:push (parse-tree:push (parse-tree:push (parse-tree:list)
                        (new-define-from-import-atom 0 0))
                        (parse-tree:child statement 1))
                        (parse-tree:child statement 2))
                        (parse-tree:atom module-name 0 0))
                    statement))

            (let (new-program
                (if (or
                        (string:equal? import-value form-name)
                        (>= statement-index (parse-tree:count program)))
                    new-program
                    (parse-tree:push new-program statement)))

            (let (module-import?
                (and
                    (string:equal? import-value form-name)
                    (not (module-list-contains?
                            imported-modules
                            (parse-tree:value
                                (parse-tree:child statement 1))))))

            (let (next-state
                (if module-import?
                    (state-with-imported-module
                        (parse-tree:value
                            (parse-tree:child statement 1)))
                    (state-for-next-statement)))

            (let (imported-modules
                (if module-import?
                    (cons
                        (parse-tree:value
                            (parse-tree:child statement 1))
                        imported-modules)
                    imported-modules))

            (self next-state new-program imported-modules)))))))))))))))))

    (convert-module
        (append-state nil (make-state program 0 (string:new) false))
        (parse-tree:list) nil))))
