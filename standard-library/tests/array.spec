
An array should be able to add and retrieve a value
> (string-of-char (array-get-or 0 66 (array-singleton 0 65)))
= A

> (string-of-char (array-get-or 1 70 (array-singleton 1 65)))
= A

> (string-of-char (array-get-or 1 70 (array-of (list (Pair 99 67) (Pair 98 66) (Pair 1 65)))))
= A

> (string-of-char (array-get-or 256 70 (array-of (list (Pair 256 65) (Pair 257 67)))))
= A

A array should return the last value added for a specific key
> (string-of-char (array-get-or 0 70 (array-set 0 65 (array-singleton 0 67))))
= A

array-of should add every entry in turn to the array
> (string-of-char (array-get-or 0 66 (array-of (list (Pair 256 67) (Pair 0 65)))))
= A

> (string-of-char (array-get-or 0 70 (array-from-list (list 65 67))))
= A

> (string-of-char (array-get-or 1 70 (array-from-list (list 65 66))))
= B
