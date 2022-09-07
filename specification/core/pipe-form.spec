
Should compose two functions together
| (def inc (x) (+ x 1))
> (pipe -1 inc inc)
= 1

Should compose several functions together
| (def inc (x) (+ x 1))
| (def half (x) (/ x 2))
> (pipe 1 inc inc inc half)
= 2

Should compose closures together
> (pipe 0 (fn (x) (+ x 1)) (fn (x) (* x 3)))
= 3

Should compose nested closures
> (pipe 1 (fn (x) ((pipe (fn (x) x) (fn (x) x)) x)) (fn (x) (* x 4)))
= 4

Should compose two partially applied functions together
| (def add (x y) (+ x y))
> (pipe -1 (add 2) (add 4))
= 5

Should isolate lambdas syntacticly
| (typ (maybe a) (Some a) None)
| (def f (x) (pipe x (fn (x) (match x (Some y) y None 0)) (fn (x) (Some x))))
> (match (f (Some 6)) (Some x) x None -1)
= 6

Should not shadow symbols
| (def x (a b) (+ a b))
> (pipe -1 (x 2) (x 4))
= 5
