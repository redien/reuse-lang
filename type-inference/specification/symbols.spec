
Should infer the type of a referenced function definition
> (def g () 1) (def f () g)
= (fn () int32) (fn () (fn () int32))
