
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
