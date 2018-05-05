
(def string-of-char (character)
     (Cons character Empty))

(def string-first (string)
     (list-first string))

(def string-rest (string)
     (list-rest string))

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

(def string-to-int32'' (string-to-int32' string accumulator x)
     (string-to-int32' string (Some (+ (* 10 accumulator) (- x 48))))) 

(def string-to-int32' (string accumulator)
     (match string
            Empty
                accumulator
            (Cons x rest)
                (maybe-flatmap (fn (accumulator)
                    ((pipe
                            (maybe-filter string-point-is-digit)
                            (maybe-flatmap (string-to-int32'' string-to-int32' rest accumulator)))
                        (Some x)))
                    accumulator)))

(def string-to-int32 (string)
     (match string
            (Cons 45 string)
                (maybe-map (fn (x) (* -1 x)) (string-to-int32 string))
            _
                (string-to-int32' string (Some 0))))

(def string-from-int32' (integer string)
     (match (> integer 9)
            True
                (string-from-int32' (/ integer 10) (Cons (+ (% integer 10) 48) string))
            False
                (Cons (+ integer 48) string)))

(def string-from-int32 (integer)
     (match (< integer 0)
            True 
                (Cons 45 (string-from-int32 (* integer -1)))
            False
                (string-from-int32' integer Empty)))

