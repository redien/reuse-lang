
Simple match expression
> (def _ () (match 1 x x))
= (def _ () (match 1 x x))

Constructor in pattern
> (def _ () (match x Empty 1))
= (def _ () (match x Empty 1))

Constructor with matches
> (def _ () (match x (Cons x xs) x))
= (def _ () (match x (Cons x xs) x))

Nested constructors
> (def _ () (match x (Cons x (Cons x xs)) x))
= (def _ () (match x (Cons x (Cons x xs)) x))

Several match rules
> (def _ () (match x 1 x 2 3))
= (def _ () (match x 1 x 2 3))

