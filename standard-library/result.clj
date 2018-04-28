
(def result-map (f result)
    (match result
        (Result x)  (Result (f x))
        error       error))

(def result-flatmap (f result)
    (match result
        (Result x)  (f x)
        error       error))
