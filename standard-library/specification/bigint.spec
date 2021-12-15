
bigint-zero
> (bigint-to-string (bigint-zero))
= 0


bigint-one
> (bigint-to-string (bigint-one))
= 1


bigint-negate
> (bigint-to-string (bigint-negate (bigint-one)))
= -1

> (bigint-to-string (bigint-negate (bigint-zero)))
= 0


bigint-from
> (bigint-to-string (bigint-from 2))
= 2

> (bigint-to-string (bigint-from -1))
= -1

> (bigint-to-string (bigint-from 10))
= 10

> (bigint-to-string (bigint-from 2147483647))
= 2147483647

> (bigint-to-string (bigint-from -2147483648))
= -2147483648


bigint-from-string
> (bigint-to-string (bigint-from-string (string-from-list (list 48))))
= 0

> (bigint-to-string (bigint-from-string (string-from-list (list 48 48))))
= 0

> (bigint-to-string (bigint-from-string (string-from-list (list 49 48))))
= 10

> (bigint-to-string (bigint-from-string (string-from-list (list 49 48 48 48 48 48 48 48 48 48 48))))
= 10000000000

> (bigint-to-string (bigint-from-string (string-from-list (list 45 49))))
= -1


bigint-add
> (bigint-to-string (bigint-add (bigint-zero) (bigint-zero)))
= 0

> (bigint-to-string (bigint-add (bigint-one) (bigint-zero)))
= 1

> (bigint-to-string (bigint-add (bigint-zero) (bigint-one)))
= 1

> (bigint-to-string (bigint-add (bigint-one) (bigint-one)))
= 2

> (bigint-to-string (bigint-add (bigint-from 9) (bigint-one)))
= 10

> (bigint-to-string (bigint-add (bigint-from 10) (bigint-one)))
= 11

> (bigint-to-string (bigint-add (bigint-one) (bigint-from 9)))
= 10

> (bigint-to-string (bigint-add (bigint-one) (bigint-from 10)))
= 11

> (bigint-to-string (bigint-add (bigint-from 10) (bigint-from 10)))
= 20

> (bigint-to-string (bigint-add (bigint-one) (bigint-from 2147483647)))
= 2147483648

> (bigint-to-string (bigint-add (bigint-from 1) (bigint-from -1)))
= 0

> (bigint-to-string (bigint-add (bigint-from -1) (bigint-from 1)))
= 0

> (bigint-to-string (bigint-add (bigint-from -1) (bigint-from -1)))
= -2


bigint-less-than
> (string-from-boolean (bigint-less-than (bigint-zero) (bigint-zero)))
= False

> (string-from-boolean (bigint-less-than (bigint-zero) (bigint-one)))
= True

> (string-from-boolean (bigint-less-than (bigint-from 10) (bigint-one)))
= False

> (string-from-boolean (bigint-less-than (bigint-one) (bigint-from 10)))
= True

> (string-from-boolean (bigint-less-than (bigint-from 10) (bigint-from 11)))
= True

> (string-from-boolean (bigint-less-than (bigint-from 100) (bigint-from 101)))
= True

> (string-from-boolean (bigint-less-than (bigint-from -1) (bigint-from 1)))
= True

> (string-from-boolean (bigint-less-than (bigint-from 0) (bigint-from -1)))
= False

> (string-from-boolean (bigint-less-than (bigint-from -2) (bigint-from -1)))
= True


bigint-subtract
> (bigint-to-string (bigint-subtract (bigint-zero) (bigint-zero)))
= 0

> (bigint-to-string (bigint-subtract (bigint-one) (bigint-zero)))
= 1

> (bigint-to-string (bigint-subtract (bigint-one) (bigint-one)))
= 0

> (bigint-to-string (bigint-subtract (bigint-from 10) (bigint-one)))
= 9

> (bigint-to-string (bigint-subtract (bigint-from 11) (bigint-one)))
= 10

> (bigint-to-string (bigint-subtract (bigint-from 11) (bigint-from 11)))
= 0

> (bigint-to-string (bigint-subtract (bigint-from 11) (bigint-from 10)))
= 1

> (bigint-to-string (bigint-subtract (bigint-from 2147483647) (bigint-from 2147483646)))
= 1

> (bigint-to-string (bigint-subtract (bigint-from 100) (bigint-one)))
= 99

> (bigint-to-string (bigint-subtract (bigint-zero) (bigint-one)))
= -1

> (bigint-to-string (bigint-subtract (bigint-zero) (bigint-from -1)))
= 1

> (bigint-to-string (bigint-subtract (bigint-from -1) (bigint-from -2)))
= 1

> (bigint-to-string (bigint-subtract (bigint-from -2) (bigint-from -1)))
= -1

> (bigint-to-string (bigint-subtract (bigint-from -2) (bigint-from 1)))
= -3

> (bigint-to-string (bigint-subtract (bigint-from -10) (bigint-from -1)))
= -9

> (bigint-to-string (bigint-subtract (bigint-from -1) (bigint-from -10)))
= 9

> (bigint-to-string (bigint-subtract (bigint-one) (bigint-from 100)))
= -99
