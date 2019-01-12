# Reuse

Reuse is a general-purpose programming language designed to compile to other programming languages. This dramatically increases the number of platforms and languages that libraries written in Reuse support.

The language is strongly typed with a complete and sound type system and decidable type inference.
The language does not support side-effects by design and all data is immutable. Any input/output or other kinds of side-effects should be handled by the host language.

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
(typ (list a) (Cons a (list a))
              Empty)
(def reduce (f initial list)
     (match list
            Empty       initial
            (Cons x xs) (reduce f (f x initial) xs)))
```

This example defines a recursive list type and a function to fold over it.

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

# Minimal and extended

Reuse has a minimal subset making it trivial to write a translator for a new language.

The extended language gives us more convenience and compiles down to the minimal subset.

## Development

Use the prepared docker image to launch a bash shell with the necessary tools:

```sh
docker run --rm -it -v $PWD:/home/opam/reuse-lang redien/reuse-lang-dev-env
```
