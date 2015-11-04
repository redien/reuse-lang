
(export list:reduce (lambda (f initial-value list)
    (if (nil? list)
        initial-value
        (self f (f initial-value (first list)) (rest list)))))

(export list:foldl list:reduce)

(export list:reverse (lambda (list)
    (list:reduce
        (lambda (a b) (cons b a))
        nil
        list)))

(export list:foldr (lambda (f initial-value list)
    (list:reduce
        (lambda (a b) (f b a))
        initial-value
        (list:reverse list))))

(export list:map (lambda (f list)
    (list:foldr
        (lambda (first rest)
            (cons
                (f first)
                rest))
        nil
        list)))

(export list:count (lambda (list)
    (let (count-with-accumulator (lambda (list count)
        (if (nil? list)
            count
            (self (rest list) (+ count 1)))))
        (count-with-accumulator list 0))))

(export list:take (lambda (list n)
    (let (take-with-accumulator (lambda (list n new-list)
        (if (== n 0)
            new-list
            (if (nil? list)
                new-list
                (self (rest list) (- n 1) (cons (first list) new-list))))))
        (list:reverse (take-with-accumulator list n nil)))))

(export list:take-last (lambda (list n)
    (list:reverse (list:take (list:reverse list) n))))

(export list:concatenate (lambda (first-list second-list)
    (let (concatenate (lambda (first-list-reversed second-list)
        (if (nil? first-list-reversed)
            second-list
            (self (rest first-list-reversed) (cons (first first-list-reversed) second-list)))))
        (concatenate (list:reverse first-list) second-list))))
