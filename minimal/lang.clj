
(def map-with-state (closure collection state)
   (match collection
          Empty           (Pair Empty state)
          (Cons ast rest) (match (apply2 closure ast state)
                                 (Pair ast state) (match (map-with-state closure rest state)
                                                         (Pair rest state) (Pair (Cons ast rest) state)))))

(def consuming-reduce (source collector reducer)
    (match source
        Empty       (Pair source collector)
        (Cons _ __) (match (reducer source collector)
                           (Pair source collector) (consuming-reduce source collector reducer))))

(data (haltable-consuming-reduce a b) (Next a b)
                                      (Halt a b))

(def haltable-consuming-reduce (source collector reducer)
   (match source
       Empty       (Pair source collector)
       (Cons _ __) (match (reducer source collector)
                          (Next source collector) (haltable-consuming-reduce source collector reducer)
                          (Halt source collector) (Pair source collector))))

(data (token a b) (SymbolToken (list a))
                  (Int32Token b)
                  OpenBracketToken
                  CloseBracketToken
                  ErrorToken)

(def whitespace? (char) (or (= char 32) (or (= char 10) (= char 13))))
(def open-bracket? (char) (= char 40))
(def close-bracket? (char) (= char 41))
(def int32-character? (char) (and (> char 47) (< char 58)))
(def initial-symbol-character? (char)
    (and (not (close-bracket? char))
    (and (not (open-bracket? char))
    (and (not (int32-character? char))
         (not (whitespace? char))))))
(def symbol-character? (char)
    (and (not (close-bracket? char))
    (and (not (open-bracket? char))
         (not (whitespace? char)))))

(def is-first-char-of (source predicate)
     (match source
            Empty         False
            (Cons char _) (predicate char)))

(def read-while' (source accumulator predicate)
    (match source
           Empty            (Pair source accumulator)
           (Cons char rest) (match (predicate char)
                                   True  (read-while' rest (Cons char accumulator) predicate)
                                   False (Pair source accumulator))))

(def read-while (source accumulator predicate)
    (match (read-while' source accumulator predicate)
           (Pair source string) (Pair source (reverse string))))

(def read-symbol-token (source tokens)
    (match (read-while source Empty symbol-character?)
           (Pair source name) (Pair source (Cons (SymbolToken name) tokens))))

(def read-int32-token (source tokens)
    (match (read-while source Empty int32-character?)
           (Pair source value) (Pair source (Cons (Int32Token value) tokens))))

(def skip-whitespace (source tokens)
    (match (read-while source Empty whitespace?)
           (Pair source _) (Pair source tokens)))

(def read-char-token (source tokens token)
    (match source
           Empty         (Pair Empty tokens)
           (Cons _ rest) (Pair rest (Cons token tokens))))

(def tokenize-next (source tokens)
    (match (is-first-char-of source whitespace?)
           True (skip-whitespace source tokens)
           False
    (match (is-first-char-of source open-bracket?)
           True (read-char-token source tokens OpenBracketToken)
           False
    (match (is-first-char-of source close-bracket?)
           True (read-char-token source tokens CloseBracketToken)
           False
    (match (is-first-char-of source int32-character?)
           True (read-int32-token source tokens)
           False
    (match (is-first-char-of source initial-symbol-character?)
           True (read-symbol-token source tokens)
           False
    (match source
           (Cons _ __) (Pair source (Cons ErrorToken tokens))
           Empty       (Pair Empty tokens))))))))

(def tokenize (source)
    (reverse (second (consuming-reduce source Empty tokenize-next))))

(data (ast name value) (Expression (list (ast name value)))
                       (Symbol name)
                       (Int32 value)
                       ParseError)

(def parse-next (tokens expression)
     (match tokens
            Empty (Halt Empty (reverse expression))
            (Cons token rest) (match token
                                     CloseBracketToken  (Halt rest (reverse expression))
                                     (SymbolToken name) (Next rest (Cons (Symbol name) expression))
                                     (Int32Token value) (Next rest (Cons (Int32 value) expression))
                                     ErrorToken         (Halt rest (Cons ParseError expression))
                                     OpenBracketToken   (match (haltable-consuming-reduce rest Empty parse-next)
                                                               (Pair tokens subExpression) (Next tokens (Cons (Expression subExpression) expression))))))

(def parse (tokens)
    (second (haltable-consuming-reduce tokens Empty parse-next)))

(def stringify-list-insert-space (asts string stringify)
    (match asts
           Empty                  string
           (Cons expression rest) (stringify-list-insert-space rest (stringify expression (Cons 32 string)) stringify)))

(def stringify-list (asts string stringify)
    (match asts
           Empty                  string
           (Cons expression rest) (stringify-list-insert-space rest (stringify expression string) stringify)))

(def stringify' (ast string)
    (match ast
        (Expression asts) (Cons 40 (stringify-list (reverse asts) (Cons 41 string) stringify'))
        (Symbol name)     (concat name string)
        (Int32 name)      (concat name string)
        ParseError        (Cons 63 string)))

(def stringify (asts)
    (stringify-list asts Empty stringify'))

(def wrap-with-expression (pair)
    (match pair
           (Pair asts state) (Pair (Expression asts) state)))

(def symbol-name-is (symbol name)
    (match symbol
           (Symbol symbol-name) (string-equal symbol-name name)
           (Int32 _)            False
           (Expression _)       False
           ParseError           False))

(def first-symbol-name-is (symbols name)
    (match symbols
           (Cons first rest) (symbol-name-is first name)
           Empty             False))
