
# Reuse
* Purely Functional
* Immutable Datastructures
* Strong Static Typing
* Algebraic Data Types

# Language
### Minimal Reuse
Written to be as easy as possible to implement in a wide range of languages and platforms and be targetable from later stages. Bootstraps the whole language on a new platform.
* S-expression parser
* LISP-1
* Garbage Collection
* No closures
* Immutable data
* Strong dynamic typing
* Algebraic Data Types
* Int32 is the only primitive type.
* Tail-call optimization
* Language is a subset of Reuse-2 and Reuse-3

**Language constructs:**
* `1` (Int32 constants)
* `(f 1)` (function application)
* `(define sum (x y) (+ x y))` (define functions)
* `(export sum (x y) (+ x y))` (define exported function with non-mangled name)
* `(data (list a) Empty (Pair a (list a)))` (define type and constructors)
* `True` (type construction)
* `(match lst Empty True (Pair x xs) False)` (destructuring and branching)
* `(+ 1 2)` (Int32 addition)
* `(- 2 1)` (Int32 subtraction)
* `(/ 4 2)` (Int32 division)
* `(* 2 3)` (Int32 multiplication)
* `(% 2 3)` (Int32 modulus)
* `(int32-compare 1 True 2 False)` (returns true if 1 is less than 2 otherwise False)

### Extended Reuse
Adds additional language features.
* Written in Reuse-1
* Modules added in a variable-rewrite step
* Closure rewriting
* String type and literals
* Macros
* Pattern matching
* Standard library
* Language is a subset of Reuse-3

**Language constructs:**
* `(let (x 1 y 2) (+ x y))` (lexical bind)
* `(fn (x y) (+ x y))` (closure)
* `(if True 1 2)` (if-expression)

# Bootstrapping
1. Transpiler of minimal reuse to host language
2. Interpreter of minimal reuse implemented in itself
3. Transpiler for extended reuse to and in minimal
4. Transpiler of extended reuse to minimal in extended.
5. Interpreter of extended reuse implemented in itself
