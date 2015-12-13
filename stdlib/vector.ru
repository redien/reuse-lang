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


(comment Functions below are not dependent on the implementation above using
    lists. It can thus be used even if the above functions are implemented
    as the host language's native data types.)

(import stdlib/transducers.ru)

(define iterator-new (lambda (vector index)
    (cons vector index)))

(define iterator-next (lambda (iterator)
    (iterator-new (first iterator) (+ (rest iterator) 1))))

(define iterator-has-next? (lambda (iterator)
    (< (rest iterator) (vector:length (first iterator)))))

(define iterator-code-point (lambda (iterator)
    (vector:element-at-index (first iterator) (rest iterator))))

(define reduce-iterator (lambda (f accumulator iterator)
    (if (iterator-has-next? iterator)
        (recur f (f accumulator (iterator-code-point iterator)) (iterator-next iterator))
        accumulator)))

(export vector:reduce (lambda (f accumulator vector)
    (reduce-iterator f accumulator (iterator-new vector 0))))

(export vector:map (lambda (f vector)
    (vector:reduce
        ((transducers:mapping f) vector:push)
        (vector:new)
        vector)))

(export vector:filter (lambda (predicate vector)
    (vector:reduce
        ((transducers:filtering predicate) vector:push)
        (vector:new)
        vector)))

(export vector:last-element (lambda (vector)
    (vector:element-at-index vector (- (vector:length vector) 1))))
