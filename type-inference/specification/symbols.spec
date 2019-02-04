
Should infer the type of a referenced function definition
> (def g () 1) (def f () g)
= (fn () int32) (fn () (fn () int32))

Should infer intrinsic functions
> (def g () +)
= (fn () (fn (int32 int32) int32))

> (def g () -)
= (fn () (fn (int32 int32) int32))

> (def g () *)
= (fn () (fn (int32 int32) int32))

> (def g () /)
= (fn () (fn (int32 int32) int32))

> (def g () %)
= (fn () (fn (int32 int32) int32))
