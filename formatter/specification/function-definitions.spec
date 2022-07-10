
Function definitions should put body on a separate line
> (def foo () (bar 1))
= 
= (def foo ()
=      (bar 1))
= 

Function definitions with public modifier
> (pub def foo () (bar 1))
= 
= (pub def foo ()
=      (bar 1))
= 

Function definitions which just define a constant should stay on one line
> (def foo () 1)
= 
= (def foo () 1)
= 
