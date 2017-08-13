
Should partially apply a binary function
| (def foo (a b) (+ a b))
> ((foo 1) 0)
= 1

Should partially apply a ternary function
| (def foo (a b c) (- a (* b c)))
> ((foo 4 1) 2)
= 2

Should partially apply closures
> (((fn (a b) (+ a b)) 2) 1)
= 3
