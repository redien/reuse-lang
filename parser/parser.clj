
(def reverse' (list new-list)
     (match list
            Empty       new-list
            (Cons x xs) (reverse' xs (Cons x new-list))))

(def reverse (list)
     (reverse' list Empty))

(def foldr (f initial list)
     (match list
            Empty       initial
            (Cons x xs) (f x (foldr f initial xs))))

(def map (f list)
     (foldr (fn (x xs)
                (Cons (f x) xs))
            Empty
            list))

(data boolean True False)
(data (pair a b) (Pair a b))

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

(def read-while' (predicate input string)
     (match input
            Empty       (Pair input string)
            (Cons x xs) (match (predicate x)
                               True  (read-while' predicate xs (Cons x string))
                               False (Pair input string))))

(def read-while (predicate input)
     (match (read-while' predicate input Empty)
            (Pair input Empty)  (Pair input Empty)
            (Pair input string) (Pair input (reverse string))))

(def skip-while (predicate input)
     (match (read-while' predicate input Empty)
            (Pair input _) input))

(def whitespace? (character)
     (= character 32))

(def not-whitespace? (character)
     (not (whitespace? character)))

(data expression (Symbol (list int32))
                 (List (list expression)))

(def push-expression (parent expression)
     (match parent
            (List list) (List (Cons expression list))
            (Symbol _)  parent))

(def parse-symbol (input list parse')
     (match (read-while not-whitespace? input)
            (Pair input name) (Pair input (push-expression list (Symbol name)))))

(def parse-list (input list parse')
     (match (parse' input (List Empty))
            (Pair input new-list) (Pair input (push-expression list new-list))))

(def parse' (input list)
     (match input
            Empty       (Pair input list)
            (Cons x xs) (match (= x 40)
                               True (parse-list xs list parse')
                  False (match (= x 41)
                               True (Pair xs list)
                  False (parse-symbol input list parse')))))

(def parse (input)
     (match (parse' (skip-while whitespace? input) (List Empty))
            (Pair _ (List (Cons expression __))) expression))

(def str (character)
     (Cons character Empty))

(def concat-strings (a b)
     (match a
            Empty       b
            (Cons x xs) (concat-strings xs (Cons x b))))

(def join (separator list)
     (foldr (fn (x xs)
                (match xs
                       Empty       (concat-strings x xs)
                       (Cons _ __) (concat-strings x (concat-strings separator xs))))
            Empty
            list))

(def stringify (input)
     (match input
            (Symbol name)      name
            (List expressions) (concat-strings (str 40) (concat-strings (join (str 32) (map stringify expressions)) (str 41)))))
