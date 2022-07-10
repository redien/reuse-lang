
Lists of a single item should be formatted on one line
> (def foo () (list 1))
= 
= (def foo ()
=      (list 1))
= 

> (def foo () (list abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 
= (def foo ()
=      (list abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ1234567890))
= 

Lists should be formatted on a single line if all items are smaller than 20 characters
> (def foo () (list abcdefghijklmnopqrs 1))
= 
= (def foo ()
=      (list abcdefghijklmnopqrs 1))
= 

Lists should be formatted with an item per line if one of the items is 20 or more characters
> (def foo () (list abcdefghijklmnopqrst 1))
= 
= (def foo ()
=      (list
=         abcdefghijklmnopqrst
=         1))
= 
