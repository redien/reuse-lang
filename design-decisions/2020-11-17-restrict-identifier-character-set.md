# Problem

- Currently identifiers can be a mix of any Unicode characters and are encoded for the target language.
- This generates undesirable identifiers in some target languages: `list_45map` or `list_45collect_45from_45indexed_45iterator_39`.
- Languages have different naming conventions and we would like to follow those.

# Changes

- Implement boolean type as a compiler intrinsic.
- Implement existing logical operators as compiler intrinsics.
- Restrict type/variable/function identifiers to be strictly lowercase latin letters and snake-case: `list-map` or `list-collect-from-indexed-iterator`.
- Restrict constructor identifiers to be strictly latin and upper camel case: `LinkedList` or `PlanB`.
- Convert identifiers to target naming convention.

# Benefits

- Users of libraries will actually want to use them.
- It's possible to convert the identifiers to the target language's naming convention.
- The backends will no longer need to encode identifiers since the character set is restricted.

# Disadvantages

- Does not support non-latin characters.
- Symbols commonly used for operators will not be usable. (Other than the ones for int32 arithmetic.)
- More operators will need to be implemented in the compiler. (Although this is arguably a good thing seeing as existing logical operators currently do not short-circuit but we would like them to.)

# Alternative solutions

- Only restrict the name of identifiers that are made public.

  - This allows the use of common operator symbols within reuse code.
  - It would still require backends to encode identifiers and additionally keep track of which ones are public.
  - Making an identifier public would require renaming all uses of it if there are encoded characters.
  - Operators could still not be made public.

- Allow a list of standard operators that get converted into text form if they're not supported by the target language.

  - There's currently no evidence that custom operators are needed.
  - They could always be added on top of the proposed solution
