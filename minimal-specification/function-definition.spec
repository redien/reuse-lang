Identity function
| (define identity (a) a)
> (identity 42)
= 42

Function with multiple arguments
| (define foo (a b) b)
> (foo 42 33)
= 33

Recursive function
| (data myCounter MyZero (MyNext myCounter))
| (define bar (a) (match a MyZero 0 (MyNext n) (bar n)))
> (bar (MyNext (MyNext MyZero)))
= 0
