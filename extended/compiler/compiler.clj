
(def compile-error () (list 42 99 111 109 112 105 108 101 32 101 114 114 111 114 42))
(def definition-end () (list 59 59))
(def let-rec () (list 108 101 116 32 114 101 99 32))
(def type () (list 116 121 112 101 32))
(def fun () (list 102 117 110 32))
(def arrow () (list 32 45 62 32))
(def space () (list 32))
(def newline () (list 10))
(def equals () (list 32 61 32))
(def comma () (list 44 32))
(def vertical-bar () (list 32 124 32))
(def colon () (list 32 58 32))
(def star () (list 32 42 32))

(def join (list) (string-join Empty list))

(def not-empty? (string)
     (not (string-empty? string)))

(def with-apostrophe (string)
     (Cons 39 string))

(def prefix-constructor (constructor)
     (Cons 67 constructor))

(def parse-error (error)
     (join (list (list 112 97 114 115 101 32 101 114 114 111 114 32)
                 (error-to-string error))))

(def translate-expression (expression)
     (match expression
            (Lambda arguments expression _)
                (wrap-in-brackets (translate-lambda arguments expression))
            (FunctionApplication expressions _)
                (match expressions
                        (Cons first Empty)
                                (wrap-in-brackets (join (list (translate-expression first) (space) (wrap-in-brackets Empty))))
                        _
                                (wrap-in-brackets (string-join (space) (list-map translate-expression expressions))))
            (IntegerConstant integer _)
                (wrap-in-brackets (string-concat (list 73 110 116 51 50 46 111 102 95 105 110 116 32)
                                                 (wrap-in-brackets (string-from-int32 integer))))
            (Identifier name _)
                name
            _
                (compile-error)))

(def translate-argument-list (arguments)
     (match (list-empty? arguments)
            True  (wrap-in-brackets Empty)
            False (string-join (space) arguments)))

(def translate-lambda (arguments expression)
     (join (list (fun)
                 (translate-argument-list arguments)
                 (arrow)
                 (translate-expression expression))))

(def translate-function-definition (name arguments expression)
     (join (list (let-rec)
                 name 
                 (equals)
                 (translate-lambda arguments expression)
                 (definition-end))))

(def translate-type (translate-types type)
     (match type
            (SimpleType name _)
                (with-apostrophe name)
            (ComplexType name types _)
                ((pipe translate-types
                       wrap-in-brackets
                       (fn (types) (join (list types (space) name)))
                ) types)))

(def translate-types (types)
     ((pipe (list-map (translate-type translate-types))
            (string-join (star))
     ) types))

(def translate-constructor-definition (type constructor)
     (match constructor
            (SimpleConstructor name _)
                (prefix-constructor name)
            (ComplexConstructor name types _)
                (join (list (prefix-constructor name) (colon) (translate-types types) (arrow) type))))

(def translate-constructor-definitions (type constructors)
     ((pipe (list-map (translate-constructor-definition type))
            (string-join (vertical-bar))
      ) constructors))

(def translate-type-parameter (parameter)
     (match parameter
            (UniversalParameter name _)
                name
            (ExistentialParameter _ __)
                Empty))

(def translate-type-parameters (parameters)
     ((pipe 
            (list-map translate-type-parameter)
            (list-filter not-empty?)
            (list-map with-apostrophe)
            (string-join (comma))
      ) parameters))

(def translate-type-name (name parameters)
     (match (translate-type-parameters parameters)
            Empty
                name
            parameters
                (join (list (wrap-in-brackets parameters)
                            (space)
                            name))))

(def translate-type-definition (name parameters constructors)
     (join (list (type)
                 (translate-type-name name parameters)
                 (equals)
                 (translate-constructor-definitions (translate-type-name name parameters) constructors)
                 (definition-end))))

(def translate-definition (definition)
     (match definition
        (FunctionDefinition name arguments expression _)
                (translate-function-definition name arguments expression)
        (ExportDefinition name arguments expression _)
                (translate-function-definition name arguments expression)
        (TypeDefinition name parameters constructors _)
                (translate-type-definition name parameters constructors)))

(def translate-result (result)
     (match result
            (Result definition)
                (translate-definition definition)
            (Error error)
                (parse-error error)))

(export to-ocaml (definitions)
        (string-join (newline) (list-map translate-result definitions)))
