
(export reduce
    (lambda (f initial-value list)
        (if (nil? list)
            initial-value
            (recur f (f (first list) initial-value) (rest list)))))

(export reverse
    (lambda (list) (reduce cons nil list)))

(export foldl reduce)

(export foldr
    (lambda (f initial-value list)
        (foldl f initial-value (reverse list))))

(export map
    (lambda (f list)
        (foldr (lambda (x xs) (cons (f x) xs)) nil list)))
