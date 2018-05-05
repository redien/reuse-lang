
(def symbol-name (symbol)
     (match symbol
            (Symbol name _)  name
            _                Empty))

(typ type          (SimpleType          (list int32) range)
                   (ComplexType         (list int32) (list type) range)
                   (FunctionType        (list type) type range))
(typ constructor   (SimpleConstructor   (list int32) range)
                   (ComplexConstructor  (list int32) (list type) range))
(typ expression    (IntegerConstant     int32 range))
(typ definition    (TypeDefinition      type (list constructor) range)
                   (FunctionDefinition  (list int32) (list (list int32)) expression range))

(typ error         (MalformedDefinitionError range)
                   (MalformedFunctionNameError range)
                   (MalformedFunctionDefinitionError range)
                   (MalformedExpressionError range)
                   (MalformedConstructorError range)
                   (MalformedTypeError range))


(def type-definition? (kind)
     (string-equal? kind (list 116 121 112)))

(def function-type? (type)
     (string-equal? type (list 102 110)))

(def function-definition? (kind)
     (string-equal? kind (list 100 101 102)))

(def sexp-to-complex-type (name parameters range)
     (result-map (fn (sub-types)
                     (ComplexType name sub-types range))
                 (sexp-to-types parameters)))

(def sexp-to-function-type (name parameters range)
     (match parameters
            (Cons (List arg-types _) (Cons return-type Empty))
                    (result-flatmap (fn (arg-types)
                    (result-map     (fn (return-type)
                                        (FunctionType arg-types return-type range))
                                    (sexp-to-type return-type)))
                                    (sexp-to-types arg-types))
            _   (Error (MalformedTypeError range))))

(def sexp-to-complex-or-function-type (name parameters range)
     (match (function-type? name)
            True   (sexp-to-function-type name parameters range)
            False  (sexp-to-complex-type name parameters range)))

(def sexp-to-type (type)
     (match type
            (List (Cons (Symbol name _) parameters) range)
                (sexp-to-complex-or-function-type name
                                                  parameters
                                                  range)
            (Symbol name range)
                (Result (SimpleType name range))
            (List _ range)
                (Error (MalformedTypeError range))))

(def sexp-to-types (types)
     (result-of-list (list-map sexp-to-type types)))

(def sexp-to-complex-constructor (name types range)
     (result-map (fn (types)
                     (ComplexConstructor name types range))
                 (sexp-to-types types)))

(def sexp-to-constructor (constructor)
     (match constructor
            (Symbol name range)
                (Result (SimpleConstructor name range))
            (List (Cons (Symbol name _) types) range)
                (sexp-to-complex-constructor name types range)
            (List _ range)
                (Error (MalformedConstructorError range))))

(def sexp-to-constructors (constructors)
     (result-of-list (list-map sexp-to-constructor constructors)))

(def sexp-to-type-definition (name constructors range)
     (result-flatmap (fn (type)
     (result-map     (fn (constructors)
                         (TypeDefinition type constructors range))
            (sexp-to-constructors constructors)))
            (sexp-to-type name)))

(def sexp-to-expression (sexp)
     (match sexp
            (Symbol symbol-name range)
                (match (string-to-int32 symbol-name) 
                       (Some integer)
                           (Result (IntegerConstant integer range))
                       None
                           (Error (MalformedExpressionError range)))
            (List _ range)
                (Error (MalformedExpression range))))

(def sexp-to-function-name (name-symbol)
     (match name-symbol
            (Symbol name _)
                (Result name))
            (List _ range)
                (Error (MalformedFunctionNameError range)))

(def sexp-to-function-arguments (rest range)
     (match rest
            (Cons (List arguments _) __)
                (Result (list-map symbol-name arguments))
            Empty
                (Error (MalformedFunctionDefinition range))))

(def sexp-to-function-expression (rest range)
     (match rest
            (Cons _ (Cons expression Empty))
                (sexp-to-expression expression)
            _
                (Error (MalformedFunctionDefinitionError range))))

(def sexp-to-function-definition (name-symbol
                                  rest
                                  range)
     (result-flatmap (fn (arguments)
     (result-flatmap (fn (expression)
     (result-map     (fn (name)
                         (FunctionDefinition name
                                             arguments
                                             expression
                                             range))
                 (sexp-to-function-name name-symbol)))
                 (sexp-to-function-expression rest range)))
                 (sexp-to-function-arguments rest range)))

(def sexp-to-definition' (kind name rest range)
     (match (type-definition? (symbol-name kind))
            True   (sexp-to-type-definition name rest range)
            False
     (match (function-definition? (symbol-name kind))
            True   (sexp-to-function-definition name rest range)
            False  (Error (MalformedDefinitionError range)))))

(def sexp-to-definition (expression)
     (match expression
            (List (Cons kind (Cons name rest)) range)
                (sexp-to-definition' kind name rest range)
            (List _ range)
                (Error (MalformedDefinitionError range))
            (Symbol _ range)
                (Error (MalformedDefinitionError range))))

(def sexps-to-definitions (expressions)
     (list-map sexp-to-definition expressions))



(def def-symbol (range)
     (Symbol (list 100 101 102) range))

(def typ-symbol (range)
     (Symbol (list 116 121 112) range))

(def fn-symbol (range)
     (Symbol (list 102 110) range))

(def type-to-sexp (type)
     (match type
            (SimpleType name range)
                (Symbol name range)
            (FunctionType arg-types return-type range)
                (List (Cons (fn-symbol range)
                      (Cons (List (types-to-sexp arg-types) range)
                      (Cons (type-to-sexp return-type) Empty))) range)
            (ComplexType name types range)
                (List (Cons (Symbol name range) (types-to-sexp types))
                      range)))

(def types-to-sexp (types)
     (list-map type-to-sexp types))

(def constructor-to-sexp (constructor)
     (match constructor
            (SimpleConstructor name range)
                (Symbol name range)
            (ComplexConstructor name types range)
                (List (Cons (Symbol name range) (types-to-sexp types))
                      range)))

(def constructors-to-sexp (constructors)
     (list-map constructor-to-sexp constructors))

(def type-definition-to-sexp (type constructors range)
     (List (list-concat (list (typ-symbol range) (type-to-sexp type))
                        (constructors-to-sexp constructors))
           range))

(def function-arguments-to-sexp (arguments range)
     (List (list-map (fn (name) (Symbol name range)) arguments) range))

(def expression-to-sexp (expression range)
     (match expression
            (IntegerConstant integer range)
                (Symbol (string-from-int32 integer) range)))

(def function-definition-to-sexp (name arguments expression range)
    (List (Cons (def-symbol range)
          (Cons (Symbol name range)
          (Cons (function-arguments-to-sexp arguments range)
          (Cons (expression-to-sexp expression range)
                Empty))))
          range))

(def definition-to-sexp (definition)
     (match definition
            (Result (TypeDefinition type constructors range))
                (type-definition-to-sexp type constructors range)
            (Result (FunctionDefinition name
                                        arguments
                                        expression
                                        range))
                (function-definition-to-sexp name
                                             arguments
                                             expression
                                             range)
            (Error _)
                (Symbol (list 33 33 33) (Range 0 0))))

(def definitions-to-sexps (definitions)
     (list-map definition-to-sexp definitions))

