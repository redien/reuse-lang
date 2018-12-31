
Should the type of a referenced function definition
> (def g () 1) (def f () g)
= (fn () (fn () int32))
