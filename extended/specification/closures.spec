
Should rewrite anonymous functions without free variables by hoisting them
> ((fn () 1))
= 1

> ((fn (x) x) 2)
= 2

> ((fn (x y) y) 2 3)
= 3

Should be able to apply returned anonymous functions
| (def f () (fn (x) x))
> ((f) 4)
= 4

Should rewrite functions with free variables
| (def f (x) ((fn () x)))
> (f 5)
= 5

| (def f (x y) ((fn () (+ x y))))
> (f 5 1)
= 6

Should be able to apply returned functions with free variables
| (def f (x) (fn () x))
> ((f 7))
= 7

Should resolve both free and bound variables
| (def f (x) (fn (y) (+ x y)))
> ((f 3) 5)
= 8
