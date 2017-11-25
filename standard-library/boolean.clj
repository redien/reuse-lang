
(typ boolean True False)

(def not (a)
     (match a
            True False
            False True))

(def and (a b)
     (match a
            True b
            False False))

(def or (a b)
     (match a
            True True
            False b))

(def < (a b)
     (int32-less-than a b True False))

(def > (a b)
     (< b a))

(def = (a b)
     (not (or (< a b) (> a b))))
