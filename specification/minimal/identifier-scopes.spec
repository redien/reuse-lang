
Function arguments can shadow the function name
| (def foo (foo) foo)
> (foo 1)
= 1
