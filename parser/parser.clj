
(def symbol-name (symbol)
     (match symbol
            (Symbol name _)  name
            _                Empty))

(typ type          (SimpleType           (list int32) range)
                   (ComplexType          (list int32) (list type) range)
                   (FunctionType         (list type) type range))
(typ constructor   (SimpleConstructor    (list int32) range)
                   (ComplexConstructor   (list int32) (list type) range))
(typ expression    (IntegerConstant      int32 range)
                   (Identifier           (list int32) range)
                   (FunctionApplication  (list expression) range))
(typ definition    (TypeDefinition       type (list constructor) range)
                   (FunctionDefinition   (list int32) (list (list int32)) expression range))

(typ error         (MalformedDefinitionError range)
                   (MalformedFunctionDefinitionError range)
                   (MalformedFunctionNameError range)
                   (MalformedExpressionError range)
                   (MalformedConstructorError range)
                   (MalformedTypeError range))

(def error-range-to-string (range)
     (match range
            (Range start end)
                 (string-concat (list 32 97 116 32)
                 (string-concat (string-from-int32 start)
                 (string-concat (list 45)
                                (string-from-int32 end))))))

(def error-to-string (error)
     (match error
            (MalformedDefinitionError range)
                (string-concat (list 77 97 108 102 111 114 109 101 100 68 101 102 105 110 105 116 105 111 110 69 114 114 111 114)
                               (error-range-to-string range))
            (MalformedFunctionDefinitionError range)
                (string-concat (list 77 97 108 102 111 114 109 101 100 70 117 110 99 116 105 111 110 68 101 102 105 110 105 116 105 111 110 69 114 114 111 114)
                               (error-range-to-string range))
            (MalformedFunctionNameError range)
                (string-concat (list 77 97 108 102 111 114 109 101 100 70 117 110 99 116 105 111 110 78 97 109 101 69 114 114 111 114)
                               (error-range-to-string range))
            (MalformedExpressionError range)
                (string-concat (list 77 97 108 102 111 114 109 101 100 69 120 112 114 101 115 115 105 111 110 69 114 114 111 114)
                               (error-range-to-string range))
            (MalformedConstructorError range)
                (string-concat (list 77 97 108 102 111 114 109 101 100 67 111 110 115 116 114 117 99 116 111 114 69 114 114 111 114)
                               (error-range-to-string range))
            (MalformedTypeError range)
                (string-concat (list 77 97 108 102 111 114 109 101 100 84 121 112 101 69 114 114 111 114)
                               (error-range-to-string range))))


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
                           (Result (Identifier symbol-name range)))
            (List expressions range)
                ((pipe
                    (list-map sexp-to-expression) 
                    result-of-list
                    (result-map (fn (expressions)
                                    (FunctionApplication expressions range))))
                 expressions)))

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

(def expression-to-sexp (expression)
     (match expression
            (IntegerConstant integer range)
                (Symbol (string-from-int32 integer) range)
            (Identifier string range)
                (Symbol string range)
            (FunctionApplication expressions range)
                (List (list-map expression-to-sexp expressions) range)))

(def function-definition-to-sexp (name arguments expression range)
    (List (Cons (def-symbol range)
          (Cons (Symbol name range)
          (Cons (function-arguments-to-sexp arguments range)
          (Cons (expression-to-sexp expression)
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
            (Error error)
                (Symbol (error-to-string error) (Range 0 0))))

(def definitions-to-sexps (definitions)
     (list-map definition-to-sexp definitions))

