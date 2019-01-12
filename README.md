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
