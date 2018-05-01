
(typ (pair a b) (Pair a b))

(def read-while' (predicate iterator string)
     (match (indexed-iterator-get iterator)
            None      (Pair iterator string)
            (Some x)  (match (predicate x)
                             True   (read-while' predicate (indexed-iterator-next iterator) (Cons x string))
                             False  (Pair iterator string))))

(def read-while (predicate iterator)
     (match (read-while' predicate iterator Empty)
            (Pair iterator Empty)  (Pair iterator Empty)
            (Pair iterator string) (Pair iterator (list-reverse string))))

(def whitespace? (character)
     (or (= character 32)
     (or (= character 13)
         (= character 10))))

(def atom-character? (character)
     (and (not (= character 40))
     (and (not (= character 41))
          (not (whitespace? character)))))

(typ range (Range int32 int32))

(typ sexp (Symbol (list int32)      range)
          (List   (list sexp)       range))

(typ (parse-result i e) (ParseNext i e)
                        (ParseOut i)
                        ParseEnd)

(def symbol-range (start end)
     (Range (indexed-iterator-index start) (indexed-iterator-index end)))

(def parse-symbol (iterator)
     (match (read-while atom-character? iterator)
            (Pair _ Empty)             (ParseOut iterator)
            (Pair next-iterator name)  (ParseNext next-iterator (Symbol name (symbol-range iterator next-iterator)))))

(def list-range (start end)
     (Range (- (indexed-iterator-index start) 1) (indexed-iterator-index end)))

(def parse-list (iterator parse-sexps)
     (match (parse-sexps iterator Empty)
            (Pair next-iterator expressions)  (ParseNext next-iterator (List expressions (list-range iterator next-iterator)))))

(def parse-expression (iterator parse-sexps)
     (match (indexed-iterator-get iterator)
            None       ParseEnd
            (Some 40)  (parse-list (indexed-iterator-next iterator) parse-sexps)
            (Some 41)  (ParseOut (indexed-iterator-next iterator))
            (Some x)   (match (whitespace? x)
                              True   (parse-expression (indexed-iterator-next iterator) parse-sexps)
                              False  (parse-symbol iterator))))

(def parse-sexps' (iterator expressions)
     (match (parse-expression iterator parse-sexps')
            ParseEnd                    (Pair iterator (list-reverse expressions))
            (ParseOut iterator)         (Pair iterator (list-reverse expressions))
            (ParseNext iterator result) (parse-sexps' iterator (Cons result expressions))))

(export parse (input)
    (match (parse-sexps' (list-to-indexed-iterator input) Empty)
        (Pair _ expressions) expressions))

(def wrap-in-brackets (string)
     (string-concat (string-of-char 40) (string-concat string (string-of-char 41))))

(def stringify-sexp (stringify expression)
     (match expression
            (Symbol name _)      name
            (List expressions _) (wrap-in-brackets (stringify expressions))))

(export stringify (expressions)
     (string-join (string-of-char 32) (list-map (stringify-sexp stringify) expressions)))
