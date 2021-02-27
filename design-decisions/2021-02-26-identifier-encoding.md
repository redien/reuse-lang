# Problem

Not all unicode characters are valid identifiers in the target languages. We would like to encode these characters
so that every identifier is unique and can still be used relatively easily.

Currently all bytes that represent alpha-numeric characters in ASCII are encoded as is and all other bytes are encoded as an underscore followed the integer byte value.

For some languages where identifiers have limited character sets we want an encoding that:

- does not break when identifiers have unicode characters
- the identifiers that do not contain unicode characters should look the same
- dashes (-) should be converted a word separator if available. For example in C it should be an underscore (\_).

For languages who has some support for unicode we would like to support it to the extent possible.

# Changes

- Encode identifiers in the following way:
  - For limited support languages
    - remove bytes not in the range 48-57, 65-90, 97-122 or 45,
  - For targets with more extensive unicode support
    - remove any characters not supported
  - if this results in an empty string, continue with a single x (120).
  - convert dashes to underscores (45 -> 95),
  - while this new string already exists
    - add an increasing numerical suffix

# Benefits

- Identifiers can contain any number of unicode characters.
- Identifiers that are mostly alpha-numeric will be easy to read and use.
- Identifiers can contain a single unicode character without making it harder to read. For example `has-foo?` will translate to `has_foo` (unless there is another identifier called `has-foo!` for example in which case the result might be `has_foo2`.)
- Encoded identifers are shorter which means there's less code to write to a file and less code for the target language compiler to parse.

# Disadvantages

- Identifiers consisting of only unicode characters will translate to just a number. Most notably the integer operators. For example + translates into x2 given it's the second identifier defined. The same applies for the identifier 識別子 and other unicode-only identifiers.
  - The encoding algorithm above has a worst case of O(n^2) when all identifiers end up with the same string.
- Identifiers need to be encoded as a whole-program operation and cannot be parallelized due to looking up duplicates.
- The resulting identifier depends on the order of declaration which makes it not ideal for exported identifiers.

# Alternative solutions

- Instead of incrementing the suffix from zero
  - Use a hash of the original identifier as the suffix then continue by incrementing
  - This improves the runtime since we can reduce the number of collisions.
  - Increases the size of all identifiers translating to the same string
