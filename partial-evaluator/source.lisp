
(data (maybe a) None
                (Some a))

(data (pair a b) (Pair a b))
(def first (pair) (match pair (Pair a b) a))
(def second (pair) (match pair (Pair a b) b))

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
           Empty newlist
           (Cons first rest) (reverse' rest (Cons first newlist))))

(def reverse (list)
   (reverse' list Empty))

(def concat (first second)
    (match first
        Empty second
        (Cons char rest) (concat rest (Cons char second))))

(def consuming-reduce (source collector reducer)
    (match source
        Empty (Pair source collector)
        (Cons _ __) (match (reducer source collector)
                           (Pair source collector) (consuming-reduce source collector reducer))))

(data (token a b) (SymbolToken (list a))
                  (Int32Token b)
                  OpenBracketToken
                  CloseBracketToken
                  ErrorToken)

(def whitespace? (char) (or (= char 32) (or (= char 10) (= char 13))))
(def open-bracket? (char) (= char 40))
(def close-bracket? (char) (= char 41))
(def int32-character? (char) (and (> char 47) (< char 58)))
(def symbol-character? (char)
  (and (not (close-bracket? char))
  (and (not (open-bracket? char))
  (and (not (int32-character? char))
       (not (whitespace? char))))))

(def is-first-char-of (source predicate)
     (match source
            Empty False
            (Cons char _) (predicate char)))

(def read-while' (source accumulator predicate)
    (match source
           Empty (Pair source accumulator)
           (Cons char rest) (match (predicate char)
                                   True (read-while' rest (Cons char accumulator) predicate)
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
           Empty (Pair Empty tokens)
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
    (match (is-first-char-of source symbol-character?)
           True (read-symbol-token source tokens)
           False
    (match source
           (Cons _ __) (Pair source (Cons ErrorToken tokens))
           Empty (Pair Empty tokens))))))))

(def tokenize (source)
    (second (consuming-reduce source Empty tokenize-next)))

(data (ast name value) (Expression (list (ast name value)))
                       (Symbol name)
                       (Int32 value)
                       ParseError)

(data (parse-result a b) (ParseNext a b)
                         (ParseStop a b))

(def parse-result-expression (result)
    (match result
        (ParseNext _ expression) expression
        (ParseStop _ expression) expression))

(def parsing-reduce (source collector reducer)
    (match source
        Empty (Pair source collector)
        (Cons _ __) (match (reducer source collector)
                           (ParseNext source collector) (parsing-reduce source collector reducer)
                           (ParseStop source collector) (Pair source collector))))

(def parse-next (tokens expression)
     (match tokens
            Empty (ParseStop Empty (reverse expression))
            (Cons token rest) (match token
                                     CloseBracketToken  (ParseStop rest (reverse expression))
                                     (SymbolToken name) (ParseNext rest (Cons (Symbol name) expression))
                                     (Int32Token value) (ParseNext rest (Cons (Int32 value) expression))
                                     ErrorToken         (ParseStop rest (Cons ParseError expression))
                                     OpenBracketToken   (match (parsing-reduce rest Empty parse-next)
                                                               (Pair tokens subExpression) (ParseNext tokens (Cons (Expression subExpression) expression))))))

(def parse (tokens)
    (Expression (second (parsing-reduce tokens Empty parse-next))))

(def stringify-list (asts string stringify)
    (match asts
           Empty string
           (Cons expression rest) (stringify expression (stringify-list rest string stringify))))

(def stringify (ast string)
    (match ast
        (Expression asts) (Cons 40 (stringify-list asts (Cons 41 string) stringify))
        (Symbol name) (Cons 32 (concat (reverse name) string))
        (Int32 name) (Cons 32 (concat (reverse name) string))
        ParseError (Cons 63 string)))

(export main (source)
        (stringify (parse (reverse (tokenize source))) Empty))
