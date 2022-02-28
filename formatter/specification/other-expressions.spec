
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

Function application should just be kept on one line
> (def g (x y) 1) (def f () (g 2 3))
= 
= (def g (x y)
=      1)
= 
= (def f ()
=      (g 2 3))
= 
