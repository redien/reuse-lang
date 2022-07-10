
Lists of a single item should be formatted on one line
> (def foo () (list 1))
= 
= (def foo ()
=      (list 1))
= 

> (def foo () (list abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 
= (def foo ()
=      (list abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 

Should format sub-expressions independently
> (def foo () (list (list 1 abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890)))
= 
= (def foo ()
=      (list (list
=         1
=         abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890)))
= 

Lists should be formatted on a single line if it fits within 60 characters
> (def foo () (list abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ 1))
= 
= (def foo ()
=      (list abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ 1))
= 

Lists should be formatted with an item per line if it's 60 or more characters
> (def foo () (list abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1 1))
= 
= (def foo ()
=      (list
=         abcdefghijklmnopqrstabcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1
=         1))
= 
