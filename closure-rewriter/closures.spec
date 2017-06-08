
Should rewrite anonymous functions without free variables by hoisting them
> ((fun () 1))
= 1

> ((fun (x) x) 2)
= 2

> ((fun (x y) y) 2 3)
= 3
