
Function arguments can shadow the function name
| (def foo (foo) foo)
> (foo 1)
= 1

A function definition can shadow a previous one
| (def foo () 1)
| (def foo () 2)
> (foo)
= 2

A function definition will not shadow a type definition
| (typ foo (Foo int32))
| (def foo () 1)
| (typ bar (Bar foo))
> (match (Bar (Foo 3)) (Bar (Foo x)) x)
= 3

A type definition will not shadow a function definition
| (def foo () 4)
| (typ foo (Foo int32))
> (foo)
= 4
