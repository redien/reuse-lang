
Function calls ending in '-bind' where the second argument is a lambda should not be indented
> (def foo () (monad-bind ma (fn (a) (monad-bind mb (fn (b) a)))))
= 
= (def foo ()
=      (monad-bind ma (fn (a)
=      (monad-bind mb (fn (b)
=      a)))))
= 

Function calls to 'bind' where the second argument is a lambda should not be indented
> (def foo () (bind ma (fn (a) (bind mb (fn (b) a)))))
= 
= (def foo ()
=      (bind ma (fn (a)
=      (bind mb (fn (b)
=      a)))))
= 

Function calls ending in 'bind' without a separator where the second argument is a lambda should be indented
> (def foo () (ebind ma (fn (a) (ebind mb (fn (b) a)))))
= 
= (def foo ()
=      (ebind ma (fn (a)
=          (ebind mb (fn (b)
=              a)))))
= 
