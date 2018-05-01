
(typ (maybe a) (Some a)
               None)

(typ (indexed-iterator (exists collection) element)
    (IndexedIterator collection
                     int32
                     (fn (collection int32) (maybe element))
                     (fn ((iterator element) collection int32) (iterator element))))

(def indexed-iterator-next (iterator)
     (match iterator
            (IndexedIterator collection index _ next)  (next iterator collection index)))

(def indexed-iterator-get (iterator)
     (match iterator
            (IndexedIterator collection index get _)  (get collection index)))

(def indexed-iterator-index (iterator)
     (match iterator
            (IndexedIterator _ index __ ___)  index))
