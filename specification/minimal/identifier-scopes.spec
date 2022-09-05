
Function arguments can shadow the function name
| (def foo (foo) foo)
> (foo 1)
= 1

A function definition can shadow a previous one
| (def foo () 1) (def foo () 2)
> (foo)
= 2
