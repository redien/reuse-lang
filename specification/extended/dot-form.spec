
Should compose two functions together
| (def inc (x) (+ x 1))
> ((. inc inc) -1)
= 1

Should compose several functions together
| (def inc (x) (+ x 1))
| (def half (x) (/ x 2))
> ((. half inc inc inc) 1)
= 2

Should compose closures together
> ((. (fn (x) (* x 3)) (fn (x) (+ x 1))) 0)
= 3

Should compose nested closures
> ((. (fn (x) (* x 4)) (fn (x) ((. (fn (x) x) (fn (x) x)) x))) 1)
= 4

Should compose two partially applied functions together
| (def add (x y) (+ x y))
> ((. (add 4) (add 2)) -1)
= 5

Should isolate lambdas syntacticly
| (typ (maybe a) (Some a) None)
| (def f (x) ((. (fn (x) (Some x)) (fn (x) (match x (Some y) y None 0))) x))
> (match (f (Some 6)) (Some x) x None -1)
= 6

Should not shadow symbols
| (def x (a b) (+ a b))
> ((. (x 4) (x 2)) -1)
= 5
