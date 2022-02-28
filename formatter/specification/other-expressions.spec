
Should format variables
> (def f (var) var)
= 
= (def f (var)
=      var)
= 

Should format constructors
> (typ a A) (def f () A)
= 
= (typ a A)
= 
= (def f ()
=      A)
= 

> (typ (a x) (A x x)) (def f () (A 1 2))
= 
= (typ (a x) (A x x))
= 
= (def f ()
=      (A 1 2))
= 
