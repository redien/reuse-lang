
Should parse the simplest function
> (def constant () 1)
= (def constant () 1)

Should parse function arguments
> (def _ (a) 1)
= (def _ (a) 1)

> (def _ (a b c) 1)
= (def _ (a b c) 1)

Should parse exported function definitions
> (export a () 1)
= (export a () 1)
