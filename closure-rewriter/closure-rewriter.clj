
(def transform (transformer ast state)
     (match (transformer ast state)
            (Some pair) pair
            None        (match ast
                               (Expression children) (wrap-with-expression (map-with-state (Closure transform transformer) children state))
                               (Symbol _)            (Pair ast state)
                               (Int32 _)             (Pair ast state)
                               ParseError            (Pair ast state))))

(data (transform-state a) (TransformState (list a)))

(def add-definition (state definition)
     (match state
            (TransformState definitions) (TransformState (Cons definition definitions))))

(def fun-string ()
     (Cons 102 (Cons 117 (Cons 110 Empty))))

(def transform-single-anonymous-function (ast state)
     (Pair (Symbol (Cons 55 Empty)) (add-definition state ast)))

(def transform-anonymous-functions (ast state)
     (match ast
            (Symbol _)            None
            (Int32 _)             None
            (Expression children) (match (first-symbol-name-is children (fun-string))
                                         True  (Some (transform-single-anonymous-function ast state))
                                         False None)
            ParseError            None))

(def partial-eval (asts)
    (match (map-with-state (Closure transform transform-anonymous-functions) asts (TransformState Empty))
           (Pair asts state) asts))

(export main (source)
    (stringify (partial-eval (parse (tokenize source)))))
