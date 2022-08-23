# Problem
We can only guarantee tail call optimizations for a subset of the calls that we could optimize in theory. When developing a program it might not be obvious when tail call optimization will happen. Therefore we'd like to explicitly say when we want the optimization to occur and be warned if it can't be optimized.

# Changes

- Introduce a new special form `(tail-call f a b c ...)` that calls a function with a list of arguments.
- Only perform tail call optimization when this special form is used.
- If the special form is placed in a position where we can't optimize the call, give an error at compile time.

# Benefits

- Make it clear when we can guarantee that the call stack won't grow.
- Provide an error when the programmer makes bad assumptions about what can be optimized for stack space.
- Can reduce the cost of trampolining where that's required by the host language by only optimizing tail calls where absolutely necessary. 

# Disadvantages

- One might introduce bugs by forgetting to add the special form.

# Alternative solutions

- Provide the special form but always optimize tail calls either way and only provide the error when they've put it in the wrong position.

# Open Questions

# Current Status

- Under Consideration
