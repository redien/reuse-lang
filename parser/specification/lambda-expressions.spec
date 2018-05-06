
Should parse a lambda expression
> (def _ () (fn () 1))
= (def _ () (fn () 1))

> (def _ () (fn (x) x))
= (def _ () (fn (x) x))

> (def _ () (fn (x y z) x))
= (def _ () (fn (x y z) x))

> (def _ () ((fn (x) x) 1))
= (def _ () ((fn (x) x) 1))

