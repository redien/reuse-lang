
Should indent the body of a lambda
> (def f () (fn () 1))
= 
= (def f ()
=      (fn ()
=          1))
= 

Should indent nested lambdas properly
> (def f () (fn () (fn () 1)))
= 
= (def f ()
=      (fn ()
=          (fn ()
=              1)))
= 
