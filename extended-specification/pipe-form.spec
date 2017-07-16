
Should compose two functions together
| (def inc (x) (+ x 1))
> ((pipe inc inc) -1)
= 1

Should compose several functions together
| (def inc (x) (+ x 1))
| (def half (x) (/ x 2))
> ((pipe inc inc inc half) 1)
= 2

Should compose closures together
> ((pipe (fun (x) (+ x 1)) (fun (x) (* x 3))) 0)
= 3

Should compose nested closures
> ((pipe (fun (x) ((pipe (fun (x) x) (fun (x) x)) x)) (fun (x) (* x 4))) 1)
= 4

Should compose two partially applied functions together
| (def add (x y) (+ x y))
> ((pipe (add 2) (add 4)) -1)
= 5
