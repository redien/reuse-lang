# Problem

- Integers are limited to 32 bits.
- They overflow.
- In the future we would probably want to support a word size of x bits instead.

# Changes

- Remove the built-in int32 type.
- Add an int type that has arbitrary precision.

# Benefits

- There's only one integer type.
- We can support integers of arbitrary size.
- We don't have to take overflow into account.
- An efficient implementation of bigint that can take advantage of the largest word size on the host.
- More efficient to implement on esoteric platforms than to first emulate 32 bit two's complement integers
- Our primitive data types are host-agnostic.

# Disadvantages

- The integer operations have extra overhead from comparisons.
- More implementation complexity for each target language.
- Integers will have to be converted to and from the host language unless a built-in type is used.

# Alternative solutions

- Keep int32 but implement a bigint type in the standard library.

  - Less efficient than an implementation that can pick the optimal word size to start with.
  - Now we have two integers to choose from and need to convert between.
  - We can only use operator symbols for one type.

- Keep int32 and introduce a built-in bigint type.
  - Now we have two integers to choose from and need to convert between.
  - We can only use operator symbols for one type.
  - Additional maintenance and implementation complexity.

# Current Status

- Under Consideration
