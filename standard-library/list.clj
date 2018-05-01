
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

(def list-filter (f list)
     (list-reverse
        (list-foldl (fn (x xs)
              (match (f x)
                     True  (Cons x xs)
                     False xs))
                    Empty
                    list)))

(def list-concat (a b)
     (match a
            Empty       b
            (Cons x xs) (Cons x (list-concat xs b))))

(def list-indexed-iterator-get (collection _)
      (match collection
             (Cons x _)  (Some x)
             Empty       None))

(def list-indexed-iterator-next (iterator collection index)
      (match collection
             (Cons _ xs)  (IndexedIterator xs (+ index 1) list-indexed-iterator-get list-indexed-iterator-next)
             Empty        iterator))

(def list-to-indexed-iterator (list)
      (IndexedIterator list 0 list-indexed-iterator-get list-indexed-iterator-next))
