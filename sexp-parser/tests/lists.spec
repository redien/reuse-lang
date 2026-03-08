
Should parse an empty list
> ()
= ()

Should parse a list in a list
> (())
= (())

Should parse several lists inside a list
> (() ())
= (() ())

Should ignore whitespace inside an empty list
> ( )
= ()

Should parse atoms inside of lists
> (a)
= (a)

> (a b)
= (a b)

> (a b c)
= (a b c)

Should parse nested lists with atoms
> (a (b))
= (a (b))

> ((a) b)
= ((a) b)

> ((a) (b))
= ((a) (b))

> (a (b) c)
= (a (b) c)
