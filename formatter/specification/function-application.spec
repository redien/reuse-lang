
Function application of a single function should be formatted on one line
> (def foo () (abc))
= 
= (def foo ()
=      (abc))
= 

> (def foo () (abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 
= (def foo ()
=      (abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 

Should format sub-expressions independently
> (def foo () (bar (bar 1 abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890)))
= 
= (def foo ()
=      (bar (bar
=         1
=         abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890)))
= 

Function application of a function with a single argument should be formatted on one line
> (def foo () (bar abc))
= 
= (def foo ()
=      (bar abc))
= 

> (def foo () (bar abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 
= (def foo ()
=      (bar abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 

Function application should be formatted on a single line if it fits within 60 characters
> (def foo () (bar abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1 1))
= 
= (def foo ()
=      (bar abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1 1))
= 

Function application should be formatted with an argument per line if it's 60 or more characters
> (def foo () (bar abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ12 1))
= 
= (def foo ()
=      (bar
=         abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ12
=         1))
= 

> (def foo () (abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ12 bar 1))
= 
= (def foo ()
=      (abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ12
=         bar
=         1))
= 
