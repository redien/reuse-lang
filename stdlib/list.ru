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

(import stdlib/transducers.ru)

(define swap (lambda (f) (lambda (a b) (f b a))))

(export list:reduce (lambda (f accumulator list)
    (if (nil? list)
        accumulator
        (recur f (f accumulator (first list)) (rest list)))))

(export list:foldl list:reduce)

(export list:reverse (lambda (list)
    (list:reduce
        (swap cons)
        nil
        list)))

(export list:foldr (lambda (f initial-value list)
    (list:reduce
        f
        initial-value
        (list:reverse list))))

(export list:map (lambda (f list)
    (list:transduce-right
        (transducers:mapping f)
        (swap cons)
        nil
        list)))

(export list:filter (lambda (predicate list)
    (list:transduce-right
        (transducers:filtering predicate)
        (swap cons)
        nil
        list)))

(export list:count (lambda (list)
    (list:transduce
        (transducers:overriding 1)
        +
        0
        list)))

(export list:take (lambda (list n)
    (let (take-with-accumulator (lambda (list n new-list)
        (if (== n 0)
            new-list
            (if (nil? list)
                new-list
                (recur (rest list) (- n 1) (cons (first list) new-list))))))
        (list:reverse (take-with-accumulator list n nil)))))

(export list:take-last (lambda (list n)
    (let (count (list:count list))
    (let (items-to-take (- count n))
    (let (list-at-hop (lambda (list index)
        (if (> index 0)
            (recur (rest list) (- index 1))
            list)))
    (list-at-hop list items-to-take))))))

(export list:concatenate (lambda (first-list second-list)
    (let (concatenate (lambda (first-list-reversed second-list)
        (if (nil? first-list-reversed)
            second-list
            (recur (rest first-list-reversed) (cons (first first-list-reversed) second-list)))))
        (concatenate (list:reverse first-list) second-list))))

(export list:transduce (lambda (transducer step initial-value list)
    (let (reducer (transducer step))
    (list:foldl reducer initial-value list))))

(export list:transduce-right (lambda (transducer step initial-value list)
    (let (reducer (transducer step))
    (list:foldr reducer initial-value list))))
