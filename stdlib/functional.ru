
(export reduce (lambda (f initial-value list)
    (if (nil? list)
        initial-value
        (recur f (f initial-value (first list)) (rest list)))))

(export foldl reduce)

(export reverse (lambda (list) (reduce (lambda (a b) (cons b a)) nil list)))

(export foldr (lambda (f initial-value list) (reduce (lambda (a b) (f b a)) initial-value (reverse list))))

(export map (lambda (f list) (foldr (lambda (first rest) (cons (f first) rest)) nil list)))
