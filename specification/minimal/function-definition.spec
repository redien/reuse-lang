Identity function
| (def identity (a) a)
> (identity 1)
= 1

Function with multiple arguments
| (def foo (a b) b)
> (foo 42 2)
= 2

Recursive function
| (typ myCounter MyZero (MyNext myCounter))
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

Functions are polymorphic
| (def left (x y) x)
| (def f (x) x)
| (def g (x) (left (f x) (f left)))
> (g 6)
= 6

Return types of functions with no arguments should generalize
| (typ (my-type a) MyEmpty (MyOther a))
| (def f () MyEmpty)
| (def g () (f))
> (match (g) MyEmpty 7 _ 99)
= 7

Public functions should act as normal functions
| (pub def foo (a b) b)
> (foo 42 8)
= 8
