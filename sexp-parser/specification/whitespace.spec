
Should ignore leading whitespace
>  1
= 1

>    1
= 1

Should ignore whitespace between expressions
> 1  2
= 1 2

> 1  2  3
= 1 2 3

> (1  2  3)
= (1 2 3)

> ()  ()  ()
= () () ()

Should ignore trailing whitespace
> (a )
= (a)

> (() )
= (())

Should ignore new-lines
> first\\nsecond
= first second
