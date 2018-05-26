
(def def-string ()
     (list 100 101 102))

(def typ-string ()
     (list 116 121 112)) 

(def fn-string ()
     (list 102 110))

(def match-string ()
     (list 109 97 116 99 104))


(def symbol-to-string (symbol)
     (match symbol
            (Symbol name _)
                (Result name)
            (List _ range)
                (Error  (MalformedSymbolError range))))

(def char-is-upper-case? (char)
     (and (>= char 65) (<= char 90)))

(def name-of-constructor? (name)
     (match name
            (Cons first-letter _)
                (char-is-upper-case? first-letter)
            Empty
                False))

(typ type          (SimpleType           (list int32) range)
                   (ComplexType          (list int32) (list type) range)
                   (FunctionType         (list type) type range))
(typ constructor   (SimpleConstructor    (list int32) range)
                   (ComplexConstructor   (list int32) (list type) range))
(typ pattern       (Capture              (list int32) range)
                   (IntegerPattern       int32 range)
                   (ConstructorPattern   (list int32) (list pattern) range))
(typ expression    (IntegerConstant      int32 range)
                   (Identifier           (list int32) range)
                   (Lambda               (list (list int32))
                                         expression
                                         range)
                   (Match                expression
                                         (list (pair expression
                                                     expression))
                                         range)
                   (FunctionApplication  (list expression) range))
(typ definition    (TypeDefinition       type (list constructor) range)
                   (FunctionDefinition   (list int32)
                                         (list (list int32))
                                         expression
                                         range))

(typ error         (MalformedDefinitionError range)
                   (MalformedFunctionDefinitionError range)
                   (MalformedFunctionNameError range)
                   (MalformedExpressionError range)
                   (MalformedSymbolError range)
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
            (MalformedSymbolError range)
                (string-concat (list 77 97 108 102 111 114 109 101 100 83 121 109 98 111 108 69 114 114 111 114)
                               (error-range-to-string range))
            (MalformedConstructorError range)
                (string-concat (list 77 97 108 102 111 114 109 101 100 67 111 110 115 116 114 117 99 116 111 114 69 114 114 111 114)
                               (error-range-to-string range))
            (MalformedTypeError range)
                (string-concat (list 77 97 108 102 111 114 109 101 100 84 121 112 101 69 114 114 111 114)
                               (error-range-to-string range))))

(def sexp-to-complex-type (name parameters range)
     (result-first (fn (sub-types)
                       (ComplexType name sub-types range))
                 (sexp-to-types parameters)))

(def sexp-to-function-type (name parameters range)
     (match parameters
            (Cons (List arg-types _) (Cons return-type Empty))
                (result-flatmap (fn (arg-types)
                (result-first   (fn (return-type)
                                    (FunctionType arg-types return-type range))
                                (sexp-to-type return-type)))
                                (sexp-to-types arg-types))
            _
                (Error (MalformedTypeError range))))

(def sexp-to-complex-or-function-type (name parameters range)
     (match (string-equal? name (fn-string))
            True   (sexp-to-function-type name parameters range)
            False  (sexp-to-complex-type name parameters range)))

(def sexp-to-type (type)
     (match type
            (List (Cons (Symbol name _) parameters) range)
                (sexp-to-complex-or-function-type name parameters range)
            (Symbol name range)
                (Result (SimpleType name range))
            (List _ range)
                (Error (MalformedTypeError range))))

(def sexp-to-types (types)
     (result-of-list (list-map sexp-to-type types)))

(def sexp-to-complex-constructor (name types range)
     (result-first (fn (types)
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
     (result-first   (fn (constructors)
                         (TypeDefinition type constructors range))
            (sexp-to-constructors constructors)))
            (sexp-to-type name)))

(def sexp-to-arguments (arguments)
     (result-of-list (list-map symbol-to-string arguments)))

(def sexp-to-function-body (range rest)
     (match rest
            (Cons (List arguments _) (Cons expression Empty))
                (Result (Pair arguments expression))
            _
                (Error (MalformedExpressionError range)))) 
 
(def sexp-to-lambda (rest range)
     (result-flatmap (fn (body)
     (result-flatmap (fn (arguments)
     (result-first   (fn (expression)
                         (Lambda arguments expression range))
                 (sexp-to-expression (pair-right body))))
                 (sexp-to-arguments (pair-left body))))
                 (sexp-to-function-body range rest)))

(def sexp-to-function-application (range expressions)
     ((pipe (list-map sexp-to-expression) 
            result-of-list
            (result-first (fn (expressions)
                              (FunctionApplication expressions range))))
         expressions))

(def to-constructor-or-capture (range name)
     (match (name-of-constructor? name)
            True  (Result (ConstructorPattern name Empty range))
            False (Result (Capture name range))))

(def sexp-to-pattern (sexp)
     (match sexp
            (List (Cons name rest) range)
                  (result-flatmap (fn (patterns)
                  (result-first   (fn (name)
                                      (ConstructorPattern name patterns range))
                                (symbol-to-string name)))
                                (result-of-list (list-map sexp-to-pattern rest)))
            (List Empty range)
                  (Error (MalformedExpressionError range))
            (Symbol name range)
                  ((pipe
                      (maybe-map  (fn (integer)
                                      (Result (IntegerPattern integer range))))
                      (maybe-else (fn () (to-constructor-or-capture range name)))
                  ) (string-to-int32 name))))

(def sexp-to-match-pair (pair)
     (match pair
            (Pair pattern expression)
                (result-flatmap (fn (pattern)
                (result-first   (fn (expression)
                                    (Pair pattern expression))
                                (sexp-to-expression expression)))
                                (sexp-to-pattern pattern))))

(def collect-pairs (list)
     (match list
            (Cons a (Cons b rest))
                (maybe-map (fn (more-pairs)
                               (Cons (Pair a b) more-pairs))
                           (collect-pairs rest))
            Empty
                (Some Empty)
            _
                None))

(def sexp-to-match-pairs (range pairs)
     ((pipe collect-pairs
            (result-of-maybe (MalformedExpressionError range))
            (result-flatmap  (pipe (list-map sexp-to-match-pair)
                                   result-of-list)))
        pairs))

(def sexp-to-match (range rest)
     (match rest
            (Cons expression rest)
                (result-flatmap (fn (expression)
                (result-first   (fn (pairs)
                                    (Match expression pairs range))
                                (sexp-to-match-pairs range rest)))
                                (sexp-to-expression expression))
            _
                (Error (MalformedExpressionError range))))

(def sexp-to-list-expression (expressions range)
     (match expressions
            (Cons (Symbol symbol _) rest) 
                  (match (string-equal? symbol (fn-string))
                         True
                             (sexp-to-lambda rest range)
                         False
                  (match (string-equal? symbol (match-string))
                         True
                             (sexp-to-match range rest)
                         False
                             (sexp-to-function-application range expressions)))
            _
                  (sexp-to-function-application range expressions)))

(def sexp-to-expression (sexp)
     (match sexp
            (Symbol symbol-name range)
                (match (string-to-int32 symbol-name) 
                       (Some integer)
                           (Result (IntegerConstant integer range))
                       None
                           (Result (Identifier symbol-name range)))
            (List expressions range)
                (match expressions
                       Empty
                          (Error (MalformedExpressionError range))
                       _ 
                          (sexp-to-list-expression expressions range))))

(def sexp-to-function-definition (name-symbol
                                  rest
                                  range)
     (result-flatmap (fn (body)
     (result-flatmap (fn (arguments)
     (result-flatmap (fn (expression)
     (result-first   (fn (name)
                         (FunctionDefinition name arguments expression range))
                 (symbol-to-string name-symbol)))
                 (sexp-to-expression (pair-right body))))
                 (sexp-to-arguments (pair-left body))))
                 (sexp-to-function-body range rest)))

(def sexp-to-definition' (name rest range kind)
     (match (string-equal? kind (typ-string))
            True   (sexp-to-type-definition name rest range)
            False
     (match (string-equal? kind (def-string))
            True   (sexp-to-function-definition name rest range)
            False  (Error (MalformedDefinitionError range)))))

(def sexp-to-definition (expression)
     (match expression
            (List (Cons kind (Cons name rest)) range)
                (result-flatmap (sexp-to-definition' name rest range) (symbol-to-string kind))
            (List _ range)
                (Error (MalformedDefinitionError range))
            (Symbol _ range)
                (Error (MalformedDefinitionError range))))

(def sexps-to-definitions (expressions)
     (list-map sexp-to-definition expressions))





(def type-to-sexp (type)
     (match type
            (SimpleType name range)
                (Symbol name range)
            (FunctionType arg-types return-type range)
                (List (Cons (Symbol (fn-string) range)
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
                (List (Cons (Symbol name range) (types-to-sexp types)) range)))

(def constructors-to-sexp (constructors)
     (list-map constructor-to-sexp constructors))

(def type-definition-to-sexp (type constructors range)
     (List (list-concat (list (Symbol (typ-string) range) (type-to-sexp type))
                        (constructors-to-sexp constructors))
           range))

(def function-arguments-to-sexp (arguments range)
     (List (list-map (fn (name) (Symbol name range)) arguments) range))

(def pattern-to-sexp (pattern)
     (match pattern
            (ConstructorPattern name Empty range)
                (Symbol name range)
            (ConstructorPattern name patterns range)
                (List (Cons (Symbol name range) (list-map pattern-to-sexp patterns)) range)
            (IntegerPattern value range)
                (Symbol (string-from-int32 value) range)
            (Capture name range)
                (Symbol name range)))

(def match-pair-to-sexp (pair)
     (match pair
            (Pair pattern expression)
               (Cons (pattern-to-sexp pattern)
               (Cons (expression-to-sexp expression) Empty))))

(def expression-to-sexp (expression)
     (match expression
            (IntegerConstant integer range)
                (Symbol (string-from-int32 integer) range)
            (Identifier string range)
                (Symbol string range)
            (Lambda arguments expression range)
                (List (Cons (Symbol (fn-string) range)
                      (Cons (function-arguments-to-sexp arguments range)
                      (Cons (expression-to-sexp expression)
                            Empty)))
                      range)
            (Match expression pairs range)
                (List (Cons (Symbol (match-string) range)
                      (Cons (expression-to-sexp expression)
                            (list-flatmap match-pair-to-sexp pairs))) range)
            (FunctionApplication expressions range)
                (List (list-map expression-to-sexp expressions) range)))

(def function-definition-to-sexp (name arguments expression range)
    (List (Cons (Symbol (def-string) range)
          (Cons (Symbol name range)
          (Cons (function-arguments-to-sexp arguments range)
          (Cons (expression-to-sexp expression)
                Empty))))
          range))

(def definition-to-sexp (definition)
     (match definition
            (TypeDefinition type constructors range)
                (type-definition-to-sexp type constructors range)
            (FunctionDefinition name arguments expression range)
                (function-definition-to-sexp name arguments expression range)))

(def error-to-sexp (error)
     (Symbol (error-to-string error) (Range 0 0)))

(def render-result (result)
     (match result
            (Result sexp)
                sexp
            (Error sexp)
                sexp))

(def definitions-to-sexps (definitions)
     (list-map (pipe (result-first definition-to-sexp)
                     (result-second error-to-sexp)
                     render-result)
               definitions))

