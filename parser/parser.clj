
(def symbol-name (symbol)
    (match symbol
        (Symbol name _)  name
        _                Empty))

(def transform (value f)
    (f value))

(typ type          (SimpleType          (list int32) range)
                   (ComplexType         (list int32) (list type) range))
(typ definition    (TypeDefinition      type sexp range)
                   (OptOut              sexp))

(typ error         MalformedDefinitionError
                   MalformedTypeError)



(def type-definition? (type)
    (string-equal? type (list 116 121 112)))

(def sexp-to-type (type)
    (match type
        (List (Cons (Symbol name _) parameters) range)
            (result-map (fn (sub-types)
                            (ComplexType name sub-types range))
                        (result-of-list (list-map sexp-to-type parameters)))
        (Symbol name range)                             (Result (SimpleType name range))
        _                                               (Error MalformedTypeError)))

(def sexp-to-definition' (kind name rest range)
    (match (type-definition? (symbol-name kind))
        True   (result-map (fn (type)
                               (TypeDefinition type rest range))
                           (sexp-to-type name))
        False  (Result (OptOut (list-concat (list kind name) rest) range))))

(def sexp-to-definition (expression)
     (match expression
        (List (Cons kind (Cons name rest)) range)  (sexp-to-definition' kind name rest range)
        _                                          (Error MalformedDefinitionError)))

(def sexps-to-definitions (expressions)
    (list-map sexp-to-definition expressions))



(def type-to-sexp (type)
    (match type
        (SimpleType name range)         (Symbol name range)
        (ComplexType name types range)  (List (list-concat (list (Symbol name range)) (list-map type-to-sexp types)) range)))

(def typ-symbol (range)
    (Symbol (list 116 121 112) range))

(def type-definition-to-sexp (type rest range)
    (List (list-concat (list (typ-symbol range) (type-to-sexp type)) rest) range))

(def definition-to-sexp (definition)
    (match definition
        (Result (TypeDefinition type rest range))  (type-definition-to-sexp type rest range)
        (Result (OptOut sexp range))               (List sexp range)
        (Error  _)                                 (Symbol (list 33 33 33) (Range 0 0))))

(def definitions-to-sexps (definitions)
    (list-map definition-to-sexp definitions))
