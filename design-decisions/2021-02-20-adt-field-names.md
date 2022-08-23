# Problem

- Writing getters/setters for each type constructor creates a lot of boilerplate.
- We would like to generate them but for that we need to give fields names so that we can name the functions.

# Changes

- Parse an additional symbol infront of field types in constructors.
- Require
  - that there is only one name for each field in a constructor and
  - that if two constructors share a field name they have to also have the same type.
- If two constructors share a field name one accessor will be generated for both.
- If one of the constructors does not have a field, the getter returns a maybe type.
- If the type is marked as public then the generated accessor will also be.

Optional changes:

- Only generate functions when they're actually referenced.
- If a user-defined function shadows an accessor then it's not generated.
- Labels are optional

```
(typ sexp
     (Symbol token: int32 text: string range: range)
     (Integer int32 range: range)
     (List sexps: (list sexp) range: range))
```

# Benefits

- No more boilerplate for accessing types without using destructuring.

# Disadvantages

- If a module would like to only export certain fields they would have to make the type private and write wrapper functions to export only certain accessors.

# Alternative solutions

- Do not generate accessors

# Current Status

- Under Consideration
