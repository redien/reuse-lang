
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

(def string-point-is-digit (point)
     (and (>= point 48) (<= point 57)))

(def string-to-int32 (string)
     (match string
            (Cons x _)
                (match (string-point-is-digit x)
                       True
                          (Some (- x 48))
                       False
                          None)
            Empty
                None))

(def string-from-int32 (integer)
     (Cons (+ integer 48) Empty))

