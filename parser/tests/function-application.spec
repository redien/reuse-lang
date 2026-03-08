
Should parse minimal function application
> (def foo () 1) (def _ () (foo))
= (def foo () 1) (def _ () (foo))

Should parse single argument function calls
> (def foo (x) x) (def _ () (foo 1))
= (def foo (x) x) (def _ () (foo 1))

Should parse n-ary functions
> (def foo (a b c) 1) (def _ () (foo 1 2 3))
= (def foo (a b c) 1) (def _ () (foo 1 2 3))
