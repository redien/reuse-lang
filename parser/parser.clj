
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

(def list-map (f list)
     (list-foldr (fn (x xs)
                     (Cons (f x) xs))
                 Empty
                 list))

(def string-of-char (character)
     (Cons character Empty))

(def string-concat (a b)
     (match a
            Empty       b
            (Cons x xs) (Cons x (string-concat xs b))))

(def 'string-join-reducer (separator)
     (fn (x xs)
         (match xs
                Empty x
                _     (string-concat (string-concat xs separator) x))))

(def string-join (separator list)
     (list-foldr ('string-join-reducer separator) Empty list))

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
            (Pair input string) (Pair input (list-reverse string))))

(def whitespace? (character)
     (or (= character 32)
     (or (= character 13)
         (= character 10))))

(def atom-character? (character)
     (and (not (= character 40))
     (and (not (= character 41))
          (not (whitespace? character)))))

(data expression (Symbol (list int32))
                 (List (list expression)))

(data (parse-result i e) (ParseNext i e)
                         (ParseOut i)
                         ParseEnd)

(def parse-symbol (input)
     (match (read-while atom-character? input)
            (Pair input Empty) (ParseOut input)
            (Pair input name)  (ParseNext input (Symbol name))))

(def parse-list (input parse-expressions)
     (match (parse-expressions input Empty)
            (Pair input expressions) (ParseNext input (List expressions))))

(def parse-expression (input parse-expressions)
     (match input
            Empty       ParseEnd
            (Cons x xs) (match (whitespace? x)
                               True (parse-expression xs parse-expressions)
                  False (match (= x 40)
                               True (parse-list xs parse-expressions)
                  False (match (= x 41)
                               True (ParseOut xs)
                  False (parse-symbol input))))))

(def parse-expressions (input expressions)
     (match (parse-expression input parse-expressions)
            ParseEnd                 (Pair Empty expressions)
            (ParseOut input)         (Pair input expressions)
            (ParseNext input result) (parse-expressions input (Cons result expressions))))

(def parse (input)
     (match (parse-expressions input Empty)
            (Pair _ expressions) expressions))

(def wrap-in-brackets (string)
     (string-concat (string-of-char 40) (string-concat string (string-of-char 41))))

(def stringify-expression (stringify expression)
     (match expression
            (Symbol name)      name
            (List expressions) (wrap-in-brackets (stringify expressions))))

(def stringify (expressions)
     (string-join (string-of-char 32) (list-map (stringify-expression stringify) expressions)))