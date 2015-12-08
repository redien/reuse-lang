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

(define underscore 95)

(define export-form (string:push (string:push (string:push (string:push (string:push (string:push (string:new) 101) 120) 112) 111) 114) 116))
(define import-form (string:push (string:push (string:push (string:push (string:push (string:push (string:new) 105) 109) 112) 111) 114) 116))
(define define-form (string:push (string:push (string:push (string:push (string:push (string:push (string:new) 100) 101) 102) 105) 110) 101))
(define define-from-import-form (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:new) 100) 101) 102) 105) 110) 101) 45) 102) 114) 111) 109) 45) 105) 109) 112) 111) 114) 116))

(define form-from-statement (lambda (statement)
    (parse-tree:value (parse-tree:child statement 0))))

(define string-exists-in-list? (lambda (string list)
    (if (nil? list)
        false
        (if (string:equal? string (first list))
            true
            (recur string (rest list))))))

(define module-already-imported? (lambda (module-name module-list)
    (string-exists-in-list? module-name module-list)))

(define is-statement-import-form? (lambda (statement)
    (string:equal? import-form (form-from-statement statement))))

(define is-statement-export-form? (lambda (statement)
    (string:equal? export-form (form-from-statement statement))))

(define is-statement-any-define-form? (lambda (statement)
    (or
        (string:equal? define-form (form-from-statement statement))
        (string:equal? define-from-import-form (form-from-statement statement)))))

(define module-name-from-statement (lambda (statement)
    (parse-tree:value
        (parse-tree:child statement 1))))

(define has-module-prefix (lambda (statement)
    (== (parse-tree:count statement) 3)))

(define module-prefix-from-statement (lambda (statement)
    (parse-tree:value (parse-tree:child statement 2))))

(define make-state (lambda (program statement-index module-name module-prefix should-redefine-exports)
    (cons program
    (cons statement-index
    (cons module-name
    (cons module-prefix
          should-redefine-exports))))))

(define append-state (lambda (state-list state)
    (cons state state-list)))

(define program-from-state (lambda (state)
    (first (first state))))

(define statement-index-from-state (lambda (state)
    (first (rest (first state)))))

(define module-name-from-state (lambda (state)
    (first (rest (rest (first state))))))

(define module-prefix-from-state (lambda (state)
    (first (rest (rest (rest (first state)))))))

(define should-redefine-exports-from-state (lambda (state)
    (rest (rest (rest (rest (first state)))))))

(define redefine-export-statement (lambda (statement module-name module-prefix)
    (parse-tree:push (parse-tree:push (parse-tree:push (parse-tree:push (parse-tree:list)
        (parse-tree:atom define-from-import-form 0 0))
        (parse-tree:atom (string:concatenate module-prefix (parse-tree:value (parse-tree:child statement 1))) 0 0))
        (parse-tree:child statement 2))
        (parse-tree:atom module-name 0 0))))

(define state-with-imported-module (lambda (module-prefix module-name imported-module next-state)
    (append-state
        next-state
        (make-state
            imported-module
            0
            module-name
            module-prefix
            true))))

(define state-for-next-statement (lambda (state module-prefix)
    (let (program (program-from-state state))
    (let (statement-index (statement-index-from-state state))
    (if (< (+ statement-index 1) (parse-tree:count program))
        (append-state
            (rest state)
            (make-state
                program
                (+ statement-index 1)
                (module-name-from-state state)
                module-prefix
                (should-redefine-exports-from-state state)))
        (rest state))))))

(export enumerate-defines (lambda (program)
    (let (enumerate-defines-with-accumulator (lambda (statement-index list)
        (if (< statement-index (parse-tree:count program))
            (let (statement (parse-tree:child program statement-index))
            (let (next-list (if (is-statement-any-define-form? statement)
                (cons (parse-tree:value (parse-tree:child statement 1)) list)
                list))
            (recur (+ statement-index 1) next-list)))
            list)))
    (enumerate-defines-with-accumulator 0 nil))))

(define scope-local-defines (lambda (program module-name)
    (let (defines (enumerate-defines program))
    (parse-tree:transform program
        (lambda (expression)
            (if (parse-tree:atom? expression)
                (string-exists-in-list? (parse-tree:value expression) defines)
                false))
        (lambda (expression)
            (parse-tree:atom
                (string:concatenate (string:push module-name underscore) (parse-tree:value expression))
                (parse-tree:line expression)
                (parse-tree:column expression)))))))

(define convert-module (lambda (program module-loader state new-program imported-modules)
    (if (nil? state)
        new-program

        (let (program (program-from-state state))
        (let (statement-index (statement-index-from-state state))
        (let (module-name (module-name-from-state state))
        (let (module-prefix (module-prefix-from-state state))
        (let (should-redefine-exports (should-redefine-exports-from-state state))

        (let (statement (parse-tree:child program statement-index))
        (let (form-name (form-from-statement statement))

        (let (statement-is-module-import
            (and
                (is-statement-import-form? statement)
                (not (module-already-imported? (module-name-from-statement statement) imported-modules))))

        (let (module-prefix
            (if (and
                    statement-is-module-import
                    (has-module-prefix statement))
                (string:push (module-prefix-from-statement statement) 58)
                module-prefix))

        (let (new-statement
            (if (and
                    should-redefine-exports
                    (is-statement-export-form? statement))
                (redefine-export-statement statement module-name module-prefix)
                statement))

        (let (new-program
            (if (or
                    (is-statement-import-form? statement)
                    (>= statement-index (parse-tree:count program)))
                new-program
                (parse-tree:push new-program new-statement)))

        (let (next-state (state-for-next-statement state module-prefix))
        (let (next-state
            (if statement-is-module-import
                (let (module-name (module-name-from-statement statement))
                (let (loaded-module (scope-local-defines (module-loader module-name) module-name))
                (if (> (parse-tree:count loaded-module) 0)
                    (state-with-imported-module module-prefix module-name loaded-module next-state)
                    next-state)))
                next-state))

        (let (imported-modules
            (if statement-is-module-import
                (cons (module-name-from-statement statement) imported-modules)
                imported-modules))

        (recur program module-loader next-state new-program imported-modules))))))))))))))))))


(export import (lambda (program module-loader)
    (if (> (parse-tree:count program) 0)
        (convert-module
            program
            module-loader
            (append-state
                nil
                (make-state program 0 (string:new) (string:new) false))
            (parse-tree:list)
            nil)
        (parse-tree:list))))
