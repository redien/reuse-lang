
(typ (maybe a) (Some a)
               None)

(def maybe-map (f maybe)
     (match maybe
            (Some x)
                (Some (f x))
            None
                None)) 

(def maybe-flatmap (f maybe)
     (match maybe
            (Some x)
                (f x)
            None
                None))

(def maybe-filter (f maybe)
     (match maybe
            (Some x)
                (match (f x)
                       True  maybe
                       False None)
            None
                None))
