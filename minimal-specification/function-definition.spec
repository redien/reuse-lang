Identity function
| (def identity (a) a)
> (identity 1)
= 1

Function with multiple arguments
| (def foo (a b) b)
> (foo 42 2)
= 2

Recursive function
| (data myCounter MyZero (MyNext myCounter))
| (def bar (a) (match a MyZero 3 (MyNext n) (bar n)))
> (bar (MyNext (MyNext MyZero)))
= 3

Function with no arguments
| (def constant () 4)
> (constant)
= 4

Calling functions passed as arguments
| (def caller (callee x) (callee x))
| (def other (x) x)
> (caller other 5)
= 5

Should be able to implement closures
| (data (closure f s) (Closure f s))
| (def apply (closure) (match closure (Closure f s) (f s)))
| (def identity (x) x)
> (apply (Closure identity 6))
= 6
