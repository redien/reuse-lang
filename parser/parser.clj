
(typ (result a b) (Result a)
                  (Error b))

(def symbol-name (symbol)
    (match symbol
        (Symbol name _)  name
        _                Empty))

(def transform (value f)
    (f value))

(typ definition    (TypeDefinition      (list int32) sexp range)
                   (OptOut              sexp))

(typ error         MalformedDefinitionError)

(def type-definition? (type)
    (string-equal? type (list 116 121 112)))

(def sexp-to-definition' (type name rest range)
    (match (type-definition? (symbol-name type))
        True   (TypeDefinition name rest range)
        False  (OptOut (list-concat (list type name) rest) range)))

(def sexp-to-definition (expression)
     (match expression
        (List (Cons type (Cons name rest)) range)  (Result (sexp-to-definition' type name rest range))
        _                                          (Error MalformedDefinitionError)))

(def sexps-to-definitions (expressions)
    (list-map sexp-to-definition expressions))

(def definition-to-sexp (definition)
    (match definition
        (Result (TypeDefinition name rest range))  (List (list-concat (list (Symbol (list 116 121 112) range) name) rest) range)
        (Result (OptOut sexp range))               (List sexp range)
        (Error  _)                                 (Symbol (list 33 33 33) (Range 0 0))))

(def definitions-to-sexps (definitions)
    (list-map definition-to-sexp definitions))
