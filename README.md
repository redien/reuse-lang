# Reuse

Reuse is a programming language that can be used in other languages.
Code written in reuse can be reused because it translates to your favorite language.
It is easy to learn and allows you to use the code you write even when
your choice of platform or framework changes.

It does not have any side-effects, no input/output and all data is immutable.
Reuse transpiles to other programming languages so that code written in Reuse can be reused. (Side-effects can be handled in the language translated to.)
The language is strongly typed with complete and decidable type inference.

# Minimal and extended

Reuse has a minimal subset making it trivial to write a translator for a new language.

The extended language gives us more convenience and compiles down to the minimal subset.

# Examples

So what does Reuse code look like?

```
(def factorial (n)
    (int32-less-than n 2
        1
        (* n (factorial (- n 1)))))
```

You might recognize this as the factorial function. (Or not, depending on what you think of parentheses.)

```
(typ (list a) (Cons a (list a)) Empty)
(def reduce (f initial list)
     (match list
            Empty       initial
            (Cons x xs) (reduce f (f x initial) xs)))
```

This example defines a recursive list type and a function to fold over it.

For more examples please look through the `minimal/specification` and `extended/specification` directories.

## Installation

#### MacOS

The Reuse compiler is distributed with Homebrew. Use the terminal to install using:

```
brew tap redien/reuse
brew install --HEAD reuse
```

#### Linux/Unix

Clone the repository and symlink `[reuse path]/frontend.sh` to the appropriate directory in your PATH.

#### Windows

Windows is currently not supported.

## Usage

```
Usage: reusec [flags] --output [OUTPUT FILE] [FILE]...

Compiler for the Reuse programming language

       --minimal         Only use the minimal subset language
       --executable      Compile an executable file
       --nostdlib        Do not include the standard library
       --output [FILE]   Write output to FILE
```

## Development

Use the prepared docker image to launch a bash shell with the necessary tools:

```sh
docker run --rm -it -v $PWD:/home/opam/reuse-lang redien/reuse-lang-dev-env
```
