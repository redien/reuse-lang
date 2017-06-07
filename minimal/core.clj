
(data (maybe a) None
                (Some a))

(data (pair a b) (Pair a b))
(def first (pair) (match pair (Pair a b) a))
(def second (pair) (match pair (Pair a b) b))
(def on-first (f pair) (match pair (Pair a b) (Pair (f a) b)))
(def on-second (f pair) (match pair (Pair a b) (Pair a (f b))))

(data boolean True False)

(def not (a) (match a
                    True False
                    False True))

(def and (a b) (match a
                      True b
                      False False))

(def or (a b) (match a
                     True True
                     False b))

(def < (a b) (int32-compare a True b False))
(def > (a b) (< b a))
(def = (a b) (not (or (< a b) (> a b))))

(data (list a) Empty
               (Cons a (list a)))

(def reverse' (list newlist)
    (match list
           Empty             newlist
           (Cons first rest) (reverse' rest (Cons first newlist))))

(def reverse (list)
   (reverse' list Empty))

(def concat' (first second)
    (match first
        Empty            second
        (Cons char rest) (concat' rest (Cons char second))))

(def concat (first second)
    (concat' (reverse first) second))

(data (closure f s) (Closure f s))
(def apply1 (closure x) (match closure (Closure f s) (f s x)))
(def apply2 (closure x y) (match closure (Closure f s) (f s x y)))

(def map (closure list)
    (match list
           Empty             Empty
           (Cons first rest) (Cons (apply1 closure first) (map closure rest))))

(def string-equal (a b)
    (match a
           (Cons a-char a-rest) (match b
                                       (Cons b-char b-rest) (and (= a-char b-char) (string-equal a-rest b-rest))
                                       Empty                False)
           Empty                (match b
                                       (Cons _ __) False
                                       Empty       True)))
