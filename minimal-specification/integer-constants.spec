Integer constants evaluate to themselves.
> 0
= 0

> 1
= 1

> -2
= -2

> 2147483647
= 2147483647

> -2147483648
= -2147483648

> -0
= 0

Integers (32-bit signed) should wrap around.
> (+ 2147483647 1)
= -2147483648

> (- -2147483648 1)
= 2147483647
