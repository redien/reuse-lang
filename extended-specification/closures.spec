
Should rewrite anonymous functions without free variables by hoisting them
> ((fun () 1))
= 1

> ((fun (x) x) 2)
= 2

> ((fun (x y) y) 2 3)
= 3

Should be able to apply returned anonymous functions
| (def f () (fun (x) x))
> ((f) 4)
= 4

Should rewrite functions with free variables
| (def f (x) ((fun () x)))
> (f 5)
= 5

| (def f (x y) ((fun () (+ x y))))
> (f 5 1)
= 6

Should be able to apply returned functions with free variables
| (def f (x) (fun () x))
> ((f 7))
= 7
