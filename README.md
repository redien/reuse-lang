
# Reuse
* Purely Functional
* Eagerly Evaluated
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
* Algebraic Data Types
* Int32 is the only primitive type
* Tail-call optimization
* Function declaration order is significant
* Proper subset of the extended language
* Target language for the extended language which compiles easily to many host languages

**Language constructs:**
* `1` (Int32 constants)
* `(f 1)` (function application)
* `(def sum (x y) (+ x y))` (define functions)
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

**Language constructs:**
* `(let (x 1 y 2) (+ x y))` (lexical bind)
* `(fn (x y) (+ x y))` (closure)
* `(if True 1 2)` (if-expression)

# Bootstrapping
1. Compiler of minimal reuse to bootstrap language (OCaml on top of Javascript)
2. Reader/Printer
3. Rewriter for full pattern matching
4. Unification
5. Inference
6. Closure rewriter for minimal reuse (makes implementing an interpreter easier.)
7. Some way of extending the compiler, either through macros or some API.
8. Write compiler with several backends

```
        ??? (reuse)   Reuse (mini-reuse)     Bootstrap (js)  Buckescript           Node.js
Macros??    ->    Reuse    ->    Minimal-Reuse    ->    Ocaml    ->    Javascript    ->    *

\* is evaluation
```
