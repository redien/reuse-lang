
# The intermediate language
The purpose of this language is giving a small, strict, purely typed functional
language that can be used as a compilation target for a larger, more useful
one.

This intermediate language is specifically created to ease compiling it down to
target languages.

# Types

### Implementing lists
A list implementation can be written using the type system.

```clojure
(data List (Cons integer List)
           Empty)

(function foldl (list List
                 f (function (integer List) List)
                 accumulator List)
                List
    (match list
        Empty accumulator
        (Cons first rest) (foldl rest f (f first accumulator))))

(function _map (value integer
                accumulator List
                f (function (integer) integer))
               List
    (Cons (f value) accumulator))

(function map (list List
               f (function (integer) integer))
              List
    (foldl list (lambda (v integer a List) (_map v a f)) Empty))

(function add_5 (x integer) integer
    (+ x 5))

(function map_add_5 (list List) List
    (map list add_5))
```

### Integers
The integers have arbitrary precision. The following operators are defined:

```clojure
(+ a b) ; a + b
(- a b) ; a - b
(* a b) ; a * b
(/ a b) ; a / b  <-- What type do we return? Optional?
(% a b) ; a % b
```

# Forms
```clojure
; Function definitions
(function name (x Integer
                y Integer
                f (function (Integer Integer) Integer))
    Integer (f x y))

; Type definitions
(data Type (Constructor PropertyType)
           (Recursive Type)
           Constant)

(function f () Type
    (let (x Type Constant) ; Let-expression
        (Recursive x))) ; Type construction
```
