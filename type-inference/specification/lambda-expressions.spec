
Should infer the type of a lambda expression
> (def f () (fn () 1))
= (fn () (fn () int32))

Should infer nested lambda expressions
> (def f () (fn () (fn () 1)))
= (fn () (fn () (fn () int32)))
