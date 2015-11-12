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

(export vector:new (lambda ()
    (cons 0 nil)))

(export vector:length (lambda (vector)
    (first vector)))

(export vector:push (lambda (vector value)
    (cons
        (+ 1 (first vector))
        (cons value (rest vector)))))

(export vector:pop (lambda (vector)
    (cons
        (- (first vector) 1)
        (rest (rest vector)))))

(export vector:element-at-index (lambda (vector index)
    (first
        (list:take-last
            (rest vector)
            (+ index 1)))))

(export vector:last-element (lambda (vector)
    (first (rest vector))))
