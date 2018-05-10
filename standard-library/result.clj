
(def result-result (result)
    (Result result))

(def result-error (error)
    (Error error))

(def result-first (f result)
    (match result
        (Result x)     (Result (f x))
        (Error error)  (Error error)))

(def result-second (f result)
    (match result
        (Result x)     (Result x)
        (Error error)  (Error (f error))))

(def result-flatmap (f result)
    (match result
        (Result x)     (f x)
        (Error error)  (Error error)))

(def result-error? (result)
     (match result
        (Error _)  True
        _          False))

(def result-filter-list (list)
     (list-foldr (fn (result new-list)
                     (match result
                            (Result x)  (Cons x new-list)
                            _           new-list))
                 Empty
                 list))

(def result-of-list (list)
    (match (list-filter result-error? list)
           (Cons (Error error) _)  (Error error)
           Empty                   (Result (result-filter-list list))))

(def result-of-maybe (error maybe)
     (match maybe
            (Some x)
                (Result x)
            None
                (Error error)))

