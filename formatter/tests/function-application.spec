
Function application of a single function should be formatted on one line
> (def foo () (abc))
= 
= (def foo ()
=      (abc))
= 

> (def foo () (abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 
= (def foo ()
=      (abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 

Should format sub-expressions independently
> (def foo () (bar (bar 1 abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890)))
= 
= (def foo ()
=      (bar (bar
=          1
=          abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890)))
= 

> (def foo () (bar 1 (bar 1 abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890)))
= 
= (def foo ()
=      (bar
=          1
=          (bar
=              1
=              abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890)))
= 

Function application of a function with a single argument should be formatted on one line
> (def foo () (bar abc))
= 
= (def foo ()
=      (bar abc))
= 

> (def foo () (bar abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 
= (def foo ()
=      (bar abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 

Function application should be formatted on a single line if it fits within 80 characters
> (def foo () (bar abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1 1))
= 
= (def foo ()
=      (bar abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1 1))
= 

Function application should be formatted with an argument per line if it's 80 or more characters
> (def foo () (bar abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ12 1))
= 
= (def foo ()
=      (bar
=          abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ12
=          1))
= 

> (def foo () (abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ12 bar 1))
= 
= (def foo ()
=      (abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ12
=          bar
=          1))
= 
