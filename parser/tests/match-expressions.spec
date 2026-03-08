
Simple match expression
> (def _ () (match 1 x x))
= (def _ () (match 1 x x))

Constructor in pattern
> (typ a A) (def _ () (match A A 1))
= (typ a A) (def _ () (match A A 1))

Constructor with matches
> (typ a (C a)) (def _ () (match 1 (C x) x))
= (typ a (C a)) (def _ () (match 1 (C x) x))

Nested constructors
> (typ a (C a a)) (def _ () (match 1 (C x (C y xs)) x))
= (typ a (C a a)) (def _ () (match 1 (C x (C y xs)) x))

Several match rules
> (def _ (x) (match x 1 x 2 3))
= (def _ (x) (match x 1 x 2 3))
