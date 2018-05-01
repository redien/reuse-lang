
(def string-of-char (character)
     (Cons character Empty))

(def string-concat (a b)
     (match a
            Empty       b
            (Cons x xs) (Cons x (string-concat xs b))))

(def 'string-join-reducer (separator)
     (fn (x xs)
         (match xs
                Empty x
                _     (string-concat (string-concat x separator) xs))))

(def string-join (separator list)
     (list-foldr ('string-join-reducer separator) Empty list))

(def string-empty? (string)
     (match string Empty True _ False))

(def string-equal? (a b)
     (match a
            (Cons xa xas) (match b
            (Cons xb xbs) (and (= xa xb) (string-equal? xas xbs))
            Empty         (string-empty? a))
            Empty         (string-empty? b)))

