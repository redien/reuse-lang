
Should rewrite anonymous functions without free variables by hoisting them
| (def f () ((fun () 1)))
> (f)
= 1
