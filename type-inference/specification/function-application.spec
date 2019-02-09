
Should infer the type of a function application
> (def f () 1) (def g () (f))
= (fn () int32) (fn () int32)

> (def a () 1) (def b () (a)) (def c () (b))
= (fn () int32) (fn () int32) (fn () int32)

> (def a () 1) (def b () a) (def c () (b))
= (fn () int32) (fn () (fn () int32)) (fn () (fn () int32))


Should infer the type of an application of the identity function
> (def identity (x) x) (def g () (identity 1))
= (fn (A) A) (fn () int32)


Should be able to call a top-level function polymorphically
> (def f (x) x) (def g () ((f f) (f 1)))
= (fn (A) A) (fn () int32)
