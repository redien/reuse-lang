# Problem

- Currently identifiers can be a mix of any Unicode characters and are encoded for the target language.
- This generates undesirable identifiers in some target languages: `list_45map` or `list_45collect_45from_45indexed_45iterator_39`.
- Languages have different naming conventions and we would like to follow those.

# Changes

- Restrict public type/function identifiers to be strictly lowercase latin letters and snake-case: `list-map` or `list-collect-from-indexed-iterator`.
- Restrict public constructor identifiers to be strictly latin and upper camel case: `LinkedList` or `PlanB`.
- Convert public identifiers to target naming convention.

# Benefits

- Users of libraries will actually want to use them.
- It's possible to convert the identifiers to the target language's naming convention.
- This still allows the use of common operator symbols within reuse code.

# Disadvantages

- We still need to encode variables making source code less readable
- Making an identifier public will still require renaming all uses of it if there are encoded characters.
- Operators could not be made public.

# Alternative solutions

- Restrict all identifiers

  - The backends will no longer need to encode identifiers since the character set is restricted.
  - Operator symbols other than built-in ones would no longer be usable
  - No unicode characters could be used
  - Would generate more readable code

- Restrict all identifiers but allow a list of standard operators that get converted into text form

  - The backends will no longer need to encode identifiers since the character set is restricted.
  - There's currently no evidence that custom operators are needed.
  - They could always be added on top of the proposed solution

# Current Status

- Not implemented
