Identity function
| (def identity (a) a)
> (identity 42)
= 42

Function with multiple arguments
| (def foo (a b) b)
> (foo 42 33)
= 33

Recursive function
| (data myCounter MyZero (MyNext myCounter))
| (def bar (a) (match a MyZero 0 (MyNext n) (bar n)))
> (bar (MyNext (MyNext MyZero)))
= 0

Function with no arguments
| (def constant () 22)
> (constant)
= 22
