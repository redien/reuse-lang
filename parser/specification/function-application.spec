
Should parse minimal function application
> (def _ () (+))
= (def _ () (+))

Should parse single argument functions
> (def _ () (+ 1))
= (def _ () (+ 1))

Should parse n-ary functions
> (def _ () (+ 1 2 3))
= (def _ () (+ 1 2 3))
