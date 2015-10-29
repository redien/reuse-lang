
(export list:reduce (lambda (f initial-value list)
    (if (nil? list)
        initial-value
        (recur f (f initial-value (first list)) (rest list)))))

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

(export list:take (lambda (list n)
    nil))
