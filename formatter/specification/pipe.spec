
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

Should format sub-expressions independently
> (def foo () (pipe (pipe 1 abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890)))
= 
= (def foo ()
=      (pipe (pipe
=         1
=         abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890)))
= 

Pipe expressions should be formatted on a single line if it fits within 60 characters
> (def foo () (pipe abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ 1))
= 
= (def foo ()
=      (pipe abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ 1))
= 

Pipe expressions should be formatted with a function per line if it's 60 or more characters
> (def foo () (pipe abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1 1))
= 
= (def foo ()
=      (pipe
=         abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1
=         1))
= 
