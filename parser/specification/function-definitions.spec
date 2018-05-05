
Should parse the simplest function
> (def constant () 1)
= (def constant () 1)

Should parse function arguments
> (def _ (a) 1)
= (def _ (a) 1)

> (def _ (a b c) 1)
= (def _ (a b c) 1)

Should parse integer constants
> (def _ () 3)
= (def _ () 3)

> (def _ () 10)
= (def _ () 10)

> (def _ () 13)
= (def _ () 13)

> (def _ () 31)
= (def _ () 31)

> (def _ () 1000000)
= (def _ () 1000000)

> (def _ () 123456)
= (def _ () 123456)

> (def _ () -1)
= (def _ () -1)

> (def _ () -2147483648)
= (def _ () -2147483648)

> (def _ () -2147483647)
= (def _ () -2147483647)

> (def _ () 2147483647)
= (def _ () 2147483647)

