
# Reuse
Reuse is a programming language designed to be small.

It does not have any side-effects, no input/output and all data is immutable.

It transpiles to other programming languages, so code written in Reuse can be reused. (Side-effects can be handled in the language translated to.)

# Minimal and extended
Reuse has a minimal subset making it trivial to write a translator to a new language.

The extended language gives us more convenience and compiles down to the minimal subset.

# Examples
So what does Reuse code look like?

```
(def factorial (n)
    (int32-compare
        n 1
        2 (* n (factorial (- n 1)))))
```

You might recognize this as the factorial function. (Or not, depending on what you think of parentheses.)



