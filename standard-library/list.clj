
(def list-reverse' (list new-list)
     (match list
            Empty       new-list
            (Cons x xs) (list-reverse' xs (Cons x new-list))))

(def list-reverse (list)
     (list-reverse' list Empty))

(def list-foldr (f initial list)
     (match list
            Empty       initial
            (Cons x xs) (f x (list-foldr f initial xs))))

(def list-foldl (f initial list)
     (match list
            Empty       initial
            (Cons x xs) (list-foldl f (f x initial) xs)))


(def list-map (f list)
     (match list
            Empty       list
            (Cons x xs) (Cons (f x) (list-map f xs))))

