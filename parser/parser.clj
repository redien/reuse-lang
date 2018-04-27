
(typ (pair a b) (Pair a b))

(def read-while' (predicate input string)
     (match input
            (Pair Empty _)       (Pair input string)
            (Pair (Cons x xs) offset)
                  (match (predicate x)
                           True  (read-while' predicate (Pair xs (+ 1 offset)) (Cons x string))
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

(typ range (Range int32 int32))

(typ sexp (Symbol (list int32)      range)
          (List   (list sexp)       range))

(typ (parse-result i e) (ParseNext i e)
                        (ParseOut i)
                        ParseEnd)

(def offset-of (input)
     (match input
            (Pair _ offset) offset))

(def symbol-range (start end)
     (Range (offset-of start) (offset-of end)))

(def parse-symbol (input)
     (match (read-while atom-character? input)
            (Pair next-input Empty) (ParseOut input)
            (Pair next-input name)  (ParseNext next-input (Symbol name (symbol-range input next-input)))))

(def list-range (start end)
     (Range (- (offset-of start) 1) (offset-of end)))

(def parse-list (input parse-sexps)
     (match (parse-sexps input Empty)
            (Pair next-input expressions) (ParseNext next-input (List expressions (list-range input next-input)))))

(def parse-expression (input parse-sexps)
     (match input
            (Pair Empty _)             ParseEnd
            (Pair (Cons 40 xs) offset) (parse-list (Pair xs (+ 1 offset)) parse-sexps)
            (Pair (Cons 41 xs) offset) (ParseOut (Pair xs (+ 1 offset)))
            (Pair (Cons x xs) offset)
                      (match (whitespace? x)
                             True  (parse-expression (Pair xs (+ 1 offset)) parse-sexps)
                             False (parse-symbol input))))

(def parse-sexps (input expressions)
     (match (parse-expression input parse-sexps)
            ParseEnd                 (Pair input (list-reverse expressions))
            (ParseOut input)         (Pair input (list-reverse expressions))
            (ParseNext input result) (parse-sexps input (Cons result expressions))))

(def wrap-in-brackets (string)
     (string-concat (string-of-char 40) (string-concat string (string-of-char 41))))

(def stringify-sexp (stringify expression)
     (match expression
            (Symbol name _)      name
            (List expressions _) (wrap-in-brackets (stringify expressions))))

(def stringify-sexps (expressions)
     (string-join (string-of-char 32) (list-map (stringify-sexp stringify-sexps) expressions)))

(typ argument-list (ArgumentList        (list (list int32))))

(typ expression    (Identifier          (list int32))
                   (Application         expression (list expression))
                   (Lambda              argument-list expression)
                   (Match               expression (list (pair expression expression)))
                   (Constructor         identifier (list expression)))

(typ type          (SimpleType          (list int32))
                   (ComplexType         (list int32) (list type)))

(typ constructor   (Constructor         (list int32) (list type)))

(typ definition    (TypeDefinition      (list int32) (list constructor))
                   (ExportDefinition    (list int32) argument-list expression)
                   (FunctionDefinition  (list int32) argument-list expression))

(def parse (input)
     (match (parse-sexps (Pair input 0) Empty)
            (Pair _ expressions) expressions))

(def stringify (expressions)
    (stringify-sexps expressions))

