# Reuse

Reuse is a general-purpose programming language designed to compile to other programming languages. This dramatically increases the number of platforms and languages that libraries written in Reuse support.

The language is strongly typed with a complete and sound type system and decidable type inference.
The language does not support side-effects by design and all data is immutable. Any input/output or other kinds of side-effects can be performed by the host language.

## Contents

- [Examples](#Examples)
- [Installation](#Installation)
- [Getting Started](#Getting-Started)
- [Language](#Language)
- [Usage](#Usage)
- [Design Rationale](#Design-Rationale)
- [Development](#Development)

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

For more examples please look through the `minimal/specification` and `extended/specification` directories.

## Installation

#### MacOS

The Reuse compiler is distributed using a Homebrew tap. Install it using the following commands:

```
brew tap redien/reuse
brew install --HEAD reuse
```

#### Linux/Unix

Clone the repository and symlink `[repository path]/reusec` to the appropriate directory in your PATH.

#### Windows

Windows support is currently not implemented.

## Getting Started

Let's create a library for the factorial function from the previous section by creating a Reuse source file called `factorial.reuse`.

```
(export factorial (n)
        (match (< n 2)
               True   1
               False  (* n (factorial (- n 1)))))
```

The one difference from the example above is that instead of simply defining a function, we're exporting it to the host language using the `export` keyword. This let's us call the function after we compile the library.

Once we've saved the source file we need to compile it using the Reuse compiler called `reusec`.

```sh
$ reusec --language ocaml --output factorial.ml factorial.reuse
```

This will compile the library we just wrote into an OCaml source file named `factorial.ml`. We can compile to all supported languages using the same Reuse source file. See the [usage section](#Usage) for a list of supported languages and the different compiler options.

Since we are using OCaml for this guide, let's write a small program that will use our library to calculate the factorial of 10 and call it `main.ml`.

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

## Usage

```
Usage: reusec [flags] --output [OUTPUT FILE] [FILE]...

Compiler for the Reuse programming language

       --minimal          Source language should be treated as Minimal Reuse
       --nostdlib         Do not include the standard library
       --language [LANG]  Target language to compile to.
                          Can be ocaml or minimal.
       --output [FILE]    Write output to FILE
```

## Design Rationale

#### Minimal and extended

Reuse has a minimal subset making it trivial to write a translator for a new language.

The extended language gives us more convenience and compiles down to the minimal subset.

## Development

Use the prepared docker image to launch a bash shell with the necessary tools:

```sh
docker run --rm -it -v $PWD:/home/opam/reuse-lang redien/reuse-lang-dev-env
```
