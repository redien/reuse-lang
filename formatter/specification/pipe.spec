
Pipe expressions of a single function should be formatted on one line
> (def foo () (pipe abc))
= 
= (def foo ()
=      (pipe abc))
= 

> (def foo () (pipe abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 
= (def foo ()
=      (pipe abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 

Pipe expressions should be formatted on a single line if all functions are smaller than 20 characters
> (def foo () (pipe abcdefghijklmnopqrs 1))
= 
= (def foo ()
=      (pipe abcdefghijklmnopqrs 1))
= 

Pipe expressions should be formatted with a function per line if one of the functions is 20 or more characters
> (def foo () (pipe abcdefghijklmnopqrst 1))
= 
= (def foo ()
=      (pipe
=         abcdefghijklmnopqrst
=         1))
= 
