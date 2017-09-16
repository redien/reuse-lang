
(typ (pair a b) (Pair a b))

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

(typ expression (Symbol (list int32))
                (List (list expression)))

(typ (parse-result i e) (ParseNext i e)
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
