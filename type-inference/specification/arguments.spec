
Should infer a universally quantified argument
> (def f (a) a)
= (fn (A) A)

Should infer a second universally quantified argument
> (def f (a b) b)
= (fn (A B) B)

Should infer a third universally quantified argument
> (def f (a b c) c)
= (fn (A B C) C)

Should infer the return type based on the expression and not the last argument
> (def f (a b) a)
= (fn (A B) A)
