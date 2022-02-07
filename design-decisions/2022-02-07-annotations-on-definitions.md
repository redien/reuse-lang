# Problem
We'd like a way of annotating functions or types so that some code external to the compiler can look at it and generate some more code based on those definitions. Examples include:

- Unit-test cases
- REST endpoints
- Generating code based on type definitions such as getters/setters or lenses.

# Changes

- Change parser to accept zero or more symbols before the `def` or `typ` keywords. The `pub` keyword would just be a special case of these used by the compiler.

# Benefits

- Allows us to generate code based on definitions without a separate list of identifiers which also needs to be kept up-to-date.
- The language is open for extension. We don't have to support problems for specific domains in the compiler.
- Backwards-compatible with existing code
- Annotations can be added without calling code having to change

# Disadvantages

- Might encourage building vast frameworks that are hard to decouple the code from.
- What if we want to add more data to a definiton?
- We might want to add annotations to specific arguments or type constructors as well.

# Alternative solutions

- Have well-defined standard interfaces like Java's JAX-RS or a built-in `test` keyword.
  - This would tie the compiler to specific domains like web-services etc.

- Arguably the keywords could just be added to the function names themselves.
  - Calling code would then be coupled to the other uses of this code since they have to specify the keywords.

# Open Questions

- Should user-defined annotations have a prefix like in Java? (`@Annotation`)
