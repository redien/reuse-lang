
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

Function application should be formatted on a single line if all arguments are smaller than 20 characters
> (def foo () (bar abcdefghijklmnopqrs 1))
= 
= (def foo ()
=      (bar abcdefghijklmnopqrs 1))
= 

Function application should be formatted with an argument per line if one of the arguments is 20 or more characters
> (def foo () (bar abcdefghijklmnopqrst 1))
= 
= (def foo ()
=      (bar
=         abcdefghijklmnopqrst
=         1))
= 

Function application should be formatted with an argument per line if the function is 20 or more characters
> (def foo () (abcdefghijklmnopqrst 0 1))
= 
= (def foo ()
=      (abcdefghijklmnopqrst
=         0
=         1))
= 
