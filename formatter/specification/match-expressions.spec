
Match expressions should have one line for patterns and one for expression, both indented
> (def f (x) (match x a 1))
= 
= (def f (x)
=      (match x
=             a
=                 1))
= 

> (def f (x) (match x 1 x 2 0))
= 
= (def f (x)
=      (match x
=             1
=                 x
=             2
=                 0))
= 

> (typ (a x) (A x x)) (def f (x) (match x (A y z) z))
= 
= (typ (a x) (A x x))
=
= (def f (x)
=      (match x
=             (A y z)
=                 z))
= 

Nested match expressions should have proper indentation
> (def f (x) (match x a (match x a 1)))
= 
= (def f (x)
=      (match x
=             a
=                 (match x
=                        a
=                            1)))
= 

Incomplete match expressions should be preserved
> (def f (x) (match x a))
= 
= (def f (x)
=      (match x
=             a
=                 ))
= 

> (def f (x) (match x a b c))
= 
= (def f (x)
=      (match x
=             a
=                 b
=             c
=                 ))
= 
