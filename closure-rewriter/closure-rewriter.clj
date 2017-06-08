
(data (transform-state a b) (TransformState (list a) b))

(def get-counter (state)
     (match state
            (TransformState _ counter) counter))

(def inc-counter (state)
     (match state
            (TransformState definitions counter) (TransformState definitions (+ counter 1))))

(def get-definitions (state)
     (match state
            (TransformState definitions _) definitions))

(def add-definitions (state new-definitions)
     (match state
            (TransformState definitions counter) (TransformState (concat new-definitions definitions) counter)))

(def fun-string ()
     (Cons 102 (Cons 117 (Cons 110 Empty))))

(def def-symbol ()
     (Symbol (Cons 100 (Cons 101 (Cons 102 Empty)))))

(def integer-to-string (integer)
     (Cons (+ integer 48) Empty))

(def construct-new-symbol (state)
     (Symbol (concat (fun-string) (integer-to-string (get-counter state)))))

(def rewrite-as-definition (children state)
     (Expression (concat (Cons (def-symbol) (Cons (construct-new-symbol state) Empty)) (rest children))))

(def transform-single-anonymous-function (children state)
     (Pair (construct-new-symbol state)
           (add-definitions (inc-counter state) (Cons (rewrite-as-definition children state) Empty))))

(def transform-anonymous-functions (ast state)
     (match ast
            (Symbol _)            None
            (Int32 _)             None
            (Expression children) (match (first-symbol-name-is children (fun-string))
                                         True  (Some (transform-single-anonymous-function children state))
                                         False None)
            ParseError            None))

(def rewrite-closures (asts)
     (match (map-with-state (Closure transform transform-anonymous-functions) asts (TransformState Empty 1))
            (Pair asts state) (concat asts (get-definitions state))))

(export main (source)
        (stringify (rewrite-closures (parse (tokenize source)))))
