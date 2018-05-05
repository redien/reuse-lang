
Should parse minimal function application
> (def _ () (f))
= (def _ () (f))

Should parse single argument functions
> (def _ () (f 1))
= (def _ () (f 1))

Should parse n-ary functions
> (def _ () (f 1 2 3))
= (def _ () (f 1 2 3))

