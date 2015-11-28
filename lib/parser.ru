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

(export error (lambda (type)
    (cons 1 type)))

(export isError (lambda (expression)
    (== (first expression) 1)))

(export errorType (lambda (expression)
    (rest expression)))

(export result (lambda (program)
    (cons 0 program)))

(export value (lambda (expression)
    (rest expression)))

(define unbalanced-parentheses-value (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:new) 117) 110) 98) 97) 108) 97) 110) 99) 101) 100) 95) 112) 97) 114) 101) 110) 116) 104) 101) 115) 101) 115))

(define unbalanced-parentheses-error
    (error unbalanced-parentheses-value))

(define whitespace? (lambda (character)
    (or (== character 32)
    (or (== character 9)
    (or (== character 10)
    (or (== character 13)
    (or (== character 160)
    (or (== character 5760)
    (or (== character 6158)
    (or (== character 8192)
    (or (== character 8193)
    (or (== character 8194)
    (or (== character 8195)
    (or (== character 8196)
    (or (== character 8197)
    (or (== character 8198)
    (or (== character 8199)
    (or (== character 8200)
    (or (== character 8201)
    (or (== character 8202)
    (or (== character 8203)
    (or (== character 8239)
    (or (== character 8287)
    (or (== character 12288)
        (== character 65279)))))))))))))))))))))))))

(define open-parenthesis 40)
(define close-parenthesis 41)
(define line-feed 10)

(define intermediate-result-new (lambda (expression index row)
    (cons 0 (cons expression (cons index row)))))

(define intermediate-result-expression (lambda (result)
    (first (rest result))))

(define intermediate-result-index (lambda (result)
    (first (rest (rest result)))))

(define intermediate-result-row (lambda (result)
    (rest (rest (rest result)))))

(define intermediate-result-new-error (lambda ()
    (cons 1 nil)))

(define intermediate-result-error? (lambda (result)
    (== (first result) 1)))


(define part-of-atom? (lambda (character)
    (not (or
            (or
                (whitespace? character)
                (== character open-parenthesis))
            (== character close-parenthesis)))))

(define parse-atom (lambda (program index row)
    (let (parse-atom-value (lambda (program index value)
        (if (< index (string:length program))
            (let (character (string:code-point-at-index program index))
            (if (part-of-atom? character)
                (recur program (+ index 1) (string:push value character))
                value))
            value)))
    (let (value (parse-atom-value program index (string:new)))
    (let (next-index (+ index (string:length value)))
    (intermediate-result-new (parse-tree:atom value row index) next-index row))))))

(define string-end? (lambda (program index)
    (>= index (string:length program))))

(define close-parenthesis? (lambda (program index)
    (and
        (< index (string:length program))
        (let (character (string:code-point-at-index program index))
        (== character close-parenthesis)))))

(define parse-expression (lambda (program index row)
    (let (character (string:code-point-at-index program index))
    (if (== character open-parenthesis)
        (parse-list program (+ index 1) row (parse-tree:list) close-parenthesis? string-end?)
        (parse-atom program index row)))))

(define parse-list (lambda (program index row list stop? error?)
    (if (stop? program index)
        (intermediate-result-new list (+ index 1) row)
    (if (error? program index)
        (intermediate-result-new-error)
        (let (character (string:code-point-at-index program index))
        (if (== character line-feed)
            (recur program (+ index 1) (+ row 1) list stop? error?)
        (if (whitespace? character)
            (recur program (+ index 1) row list stop? error?)
            (let (intermediate-result (parse-expression program index row))
            (if (intermediate-result-error? intermediate-result)
                intermediate-result
                (let (expression (intermediate-result-expression intermediate-result))
                (let (next-index (intermediate-result-index intermediate-result))
                (let (next-row (intermediate-result-row intermediate-result))
                (recur program next-index next-row (parse-tree:push list expression) stop? error?)))))))))))))

(export parse (lambda (program)
    (let (intermediate-result (parse-list program 0 1 (parse-tree:list) string-end? close-parenthesis?))
    (if (intermediate-result-error? intermediate-result)
        unbalanced-parentheses-error
        (let (parsed-program (intermediate-result-expression intermediate-result))
        (result parsed-program))))))
