
Should give int32 as return type
> (def f () 1)
= (fn () int32)

Should infer integer type from plus operator
> (def f () (+ 1 2))
= (fn () int32)

Should infer integer type from minus operator
> (def f () (- 1 2))
= (fn () int32)

Should infer integer type from multiplication operator
> (def f () (* 1 2))
= (fn () int32)

Should infer integer type from division operator
> (def f () (/ 1 2))
= (fn () int32)

Should infer integer type from modulus operator
> (def f () (% 1 2))
= (fn () int32)
