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

Calling functions passed as arguments
| (def caller (callee x) (callee x))
| (def other (x) x)
> (caller other 12)
= 12

Should be able to implement closures
| (data (closure f s) (Closure f s))
| (def apply (closure) (match closure (Closure f s) (f s)))
| (def identity (x) x)
> (apply (Closure identity 13))
= 13
