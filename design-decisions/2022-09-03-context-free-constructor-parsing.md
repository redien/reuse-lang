# Problem

When referencing constructors in an expression the parser cannot distinguish between a constructor and a function
call. In match expressions constructors can't be distinguished from capture variables. Currently the parser keeps
track of the identifiers that are constructors. Consider the following:

(match error
       ErrorValue  1
       _           0)

If ErrorValue is misspelled or if it's not accessible from this module then it'll be interpreted as a capture variable
and that case will be taken regardless of the actual value. It's impossible to determine from just looking at the
expression if the identifier is a constructor or not.

This also complicates the parser as it needs to wait until after all identifiers are resolved to determine if an
identifier refers to a constructor or not.

# Changes

- Constructors have to be capitalized.
- Variables or identifiers cannot be capitalized and will give an error if they are defined capitalized.

# Benefits

- Constructors can be parsed context free.
- Constructors will be recognized as constructors even when they're not accessible or do not exist.
- It's possible to determine if an identifier is a constructor from the syntax.

# Disadvantages

- Constructors with non-latin characters have to be prefixed by a capital latin letter.

# Alternative solutions

- Prefix constructor identifiers with a special character
  - Identifiers in all languages are treated the same.
  - Adds extra noise to identifiers
  - If you forget to add the prefix character it won't be treated as a constructor

- Keep the current behaviour which keeps tracks of which identifiers are constructors
  - Identifiers in all languages are treated the same.
  - Adds more work for the parser after resolving identifiers.
  - A constructor will be treated as a non-constructor if it's not accessible or misspelled.

- Prefix identifiers other than constructors with a special character
  - Adds more noise than prefixing constructors
  - Identifiers in all languages are treated the same.
  - If you forget to add the prefix character it'll be treated as a constructor

# Open Questions

# Current Status

- Implementation Planned
