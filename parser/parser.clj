
(data boolean True False)

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
     (int32-compare a True b False))

(def > (a b)
     (< b a))

(def = (a b)
     (not (or (< a b) (> a b))))

(def skip-while (f input)
     (match input
            Empty       input
            (Cons x xs) (match (f x)
                               True  (skip-while f xs)
                               False input)))

(def whitespace? (character)
     (= character 32))

(def parse (input) (skip-while whitespace? input))

(def stringify (input) input)
