# Problem

- Currently there's an initial parsing step that produces a tree of s-expressions and a table of token ids to strings. This abstraction provides little value but increases the conceptual complexity of the compiler. It was implemented as an optimization to remove string comparisons.
- Since the host language can more efficiently split an input string into substrings we would like to extract this part.

# Changes

- Write an initial step in the host language that tokenizes the input language.
- Remove the s-expression parsing step and integrate it into the language parser.

# Benefits

- We can more efficiently split the input string into symbols.
- We reduce conceptual complexity by merging the s-expression step with the rest of the parser.
- Splitting the input into tokens is a simpler task for the host language so less code is required.
- A token stream is a more general API and will still be usable if we move away from s-expressions.

# Disadvantages

- More of the compiler needs to be written in the host language.

# Alternative solutions

- Write an s-expression parser in the host language

  - Provides the same performance benefits.
  - But does nothing to reduce the conceptual complexity.
  - More code is needed in the host language.

- Optimize string operations and write the parser completely in Reuse

  - The most portable solution.
  - Additional language primitives are needed to reduce allocations when building substrings.
  - The tokenizer could always be rewritten in reuse if the allocation issues are solved.
