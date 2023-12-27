# Reuse

[![CI](https://github.com/redien/reuse-lang/workflows/CI/badge.svg)](https://github.com/redien/reuse-lang/actions?query=workflow%3ACI)

**WARNING: Reuse is experimental software and should not be used for systems where security, safety, availability, integrity or confidentiality is needed.**

Reuse exists to create a universal standard library. It is a general-purpose programming language designed to compile to other programming languages. This dramatically increases the number of platforms and languages that libraries written in Reuse support.

The language is statically typed, does not support side-effects by design and all data is immutable. Any input/output or other kinds of side-effects can be performed by the host language.

## Table of Contents

- [Examples](#Examples)
- [Installation](#Installation)
- [Getting Started](#Getting-Started)
- [Language](#Language)
- [Usage](#Usage)
- [Design Rationale](#Design-Rationale)
- [Development](#Development)
- [Todo](#Todo)

## Examples

This is what a factorial function looks like in Reuse:

```
(def factorial (n)
     (match (< n 2)
            True   1
            False  (* n (factorial (- n 1)))))
```

Another example involving algebraic data-types:

```
(typ (list a) (Cons a (list a))
              Empty)

(def reduce (f initial list)
     (match list
            Empty       initial
            (Cons x xs) (reduce f (f x initial) xs)))
```

For more examples please look through the `specification/core` directory. Also see the [getting started section](#Getting-Started).

## Installation

**MacOS**

The Reuse compiler is distributed using a Homebrew tap. Install it using the following commands:

```
brew tap redien/reuse
brew install --HEAD reuse
```

**Linux/Unix**

Clone the repository, build using `[repository path]/build.sh` and symlink `[repository path]/reusec` to the appropriate directory in your PATH. It currently requires the [OCaml compiler](https://ocaml.org/) to bootstrap.

**Windows**

Windows support is currently not implemented.

## Getting Started

Let's create a library for the factorial function from the previous section by creating a Reuse source file called `factorial.reuse`.

```
(def factorial (n)
     (match (< n 2)
            True   1
            False  (* n (factorial (- n 1)))))
```

Once we've saved the source file we need to compile it using the Reuse compiler called `reusec`.

```sh
$ reusec --language ocaml --output factorial.ml factorial.reuse
```

This will compile the library we just wrote into an OCaml source file named `factorial.ml`. We can compile to all supported languages using the same Reuse source file. See the [usage section](#Usage) for a list of supported languages and the different compiler options.

Let's write a small OCaml program that will use our library to calculate the factorial of 10. We write it in a file we'll name `main.ml`.

```ocaml
Printf.printf "%ld\n" (Factorial.factorial 10l)
```

Reuse has an integer type of 32 bits while OCaml's default integers vary in size. This is why we need to represent the constant 10 as `10l` to tell the OCaml compiler to treat it as a 32 bit integer.

We can now compile the example using the OCaml compiler.

```sh
$ ocamlopt -c factorial.ml
$ ocamlopt -c main.ml
$ ocamlopt -o factorial factorial.cmx main.cmx
```

And finally if we run the compiled program we should get the correct result for the factorial of 10.

```sh
$ ./factorial
3628800
```

## Language

**Integer manipulation**

The int32 type is a 32-bit signed integer.

```
(+ 1 2)    3
(- 1 2)    -1
(* 1 2)    2
(/ 1 2)    0
(% 1 2)    1

(= 1 2)    False
(< 1 2)    True
(> 1 2)    True
(>= 1 2)   False
(<= 1 2)   True
```

**Boolean operators**

```
(and True False)    False
(or True False)     True
(not True)          False
```

**Function Definition**

```
(def identity (x)
     x)
```

## Usage

```
Usage: reusec [flags] --output [OUTPUT FILE] [FILE]...

Compiler for the Reuse programming language

       --stdlib [BOOL]    Include the standard library, default: true
       --language [LANG]  Target language to compile to
       --output [FILE]    Write output to FILE
       -h                 Print usage information
       -f                 Format input files by writing directly to them

Languages: haskell javascript module ocaml
```

## Design Restrictions

- Possible to reasonably map reuse to as many target languages as possible.
- Be able to maintain hundreds of backends for different languages.

## Design Rationale

- Keeping the language as small as possible
  - Pro: Reduces the work of implementing new language targets and tools
  - Pro: Fewer features to learn
  - Con: Not as expressive as it could be
- No mutability
  - Pro: Easy to translate to pure and non-pure languages
  - Pro: Regain the free lunch: Make parallel programming a breeze
  - Pro: [No more value restriction as there is no mutability](https://ocamlverse.github.io/content/weak_type_variables.html)
  - Con: Makes it difficult to avoid heap allocations
  - Con: Poor cache locality
- Strict evaluation
  - Pro: Does not behave "badly" when compiled to a lazy language
  - Con: Not as expressive as lazy evaluation
- No let expression
  - Pro: let generalization is [not frequently used](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/tldi10-vytiniotis.pdf).
  - Pro: A match expression can work just as well as a let expression
  - Con: Might encourage breaking up functions that would be better understood as just one

## Development

Use the prepared docker image to launch a bash shell with the necessary tools:

```sh
docker run --rm -it -v $PWD:/home/opam/reuse-lang redien/reuse-lang-dev-env
```

## Popular library types that could be built with reuse

- Parsing, manipulation and serialization of:
  - Semver
  - Date & Time
  - URIs
- Encoder/decoder of:
  - JSON
  - YAML
  - TOML
  - INI
  - .env
  - .properties
  - CBOR
  - msgpack
- Command-line parser and usage generator
- ASCII table generator
- ASCII progress bar

## Todo

- Re-implement a javascript backend to get a debugger for free
  - Implement source maps to improve debugging experience
- Generate new names for duplicate entries in the symbol table
  - Resolve module identifiers as a step after parsing
    - Save the name/module of the identifier in the symbol table
    - By keeping the module identifier separate (split by colon?), identifiers can be resolved lazily
    - Keeping the name means that different threads do not have to coordinate their IDs
    - Merge symbol tables together to get one table
- Escape identifiers by adding the new identifier to the symbol table entry
- Use symbol table in the backend
- Handle division by zero safely
  - Return INT32_MAX?
  - Return Maybe?
- Research alternative number representations.
  - Big num?
  - dec64?
  - int64?
  - uint8?

**Performance**

- Instead of interning strings, compute a hash that replaces the ID and perform a string compare if hashes match
  - Also perform static tokenization by hard-coding keywords into sexp-parser.
  - This allows parallell sexp parsing again
- Reduce the allocations in local transforms by not allocating new AST nodes when nothing changes
- Fuse local transformation steps

**Thoughts on a parens-less syntax**

```
type sexp
   | Symbol   string       range
   | Integer  int32        range
   | List     (list sexp)  range

type parse-error
   | ParseErrorTooFewClosingBrackets
   | ParseErrorTooManyClosingBrackets

func identifier-range start end
     Range (indexed-iterator-index start) (indexed-iterator-index end)

func parse-symbol iterator end next
     case string-collect-from-indexed-iterator atom-character? iterator
        | Pair next-iterator name
               case string-to-int32 name
                  | Some integer
                       next next-iterator (Integer integer (identifier-range iterator next-iterator))
                  | None
               case string-empty? name
                  | False
                       next next-iterator (Symbol name (identifier-range iterator next-iterator))
                  | True
                       end iterator

...


func sexp-to-function-type sexp-to-types sexp-to-type name parameters range
     case parameters
        | Cons (List arg-types _) (Cons return-type Empty)
               result-bind   (sexp-to-types arg-types)   func arg-types
               result-bind   (sexp-to-type return-type)  func return-type
               result-return (FunctionType arg-types return-type range)
        | _
               Error (MalformedTypeError range)
```

- Indentation is not significant
- All keywords are 4 characters wide to make indenting easier
- type expects a type name, arguments and then a constructor on each new line
- func expects a name (only top-level), arguments and then the body on a new line
- case expects an expression and patterns on each line with a `->` followed by an expression
- function application cannot span several lines unless the line is broken up by a func or case expression
- sub-expressions need parens
