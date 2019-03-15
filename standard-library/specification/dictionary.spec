
A dictionary should be able to add and retrieve a value
> (string-of-char (dictionary-get-or (string-empty) 66 (dictionary-singleton (string-empty) 65)))
= A

> (string-of-char (dictionary-get-or (string-of-char 1) 70 (dictionary-singleton (string-of-char 1) 65)))
= A

> (string-of-char (dictionary-get-or (string-of-char 1) 70 (dictionary-of (list (Pair (string-of-char 99) 67) (Pair (string-of-char 98) 66) (Pair (string-of-char 1) 65)))))
= A

> (string-of-char (dictionary-get-or (string-from-list (list 1 2)) 70 (dictionary-of (list (Pair (string-from-list (list 1 2)) 65) (Pair (string-from-list (list 2 2)) 67)))))
= A

> (string-of-char (dictionary-get-or (string-of-char 1) 70 (dictionary-of (list (Pair (string-of-char 99) 67) (Pair (string-of-char 1) 65) (Pair (string-of-char 98) 66)))))
= A

> (string-of-char (dictionary-get-or (string-of-char 1) 70 (dictionary-of (list (Pair (string-of-char 1) 65) (Pair (string-of-char 99) 67) (Pair (string-of-char 98) 66)))))
= A

> (string-of-char (dictionary-get-or (string-from-list (list 1 2)) 70 (dictionary-of (list (Pair (string-of-char 1) 67) (Pair (string-from-list (list 1 2)) 65)))))
= A

> (string-of-char (dictionary-get-or (string-from-list (list 1 2 3 4 6)) 70 (dictionary-of (list (Pair (string-from-list (list 1 2 3 4 5)) 67) (Pair (string-from-list (list 1 2 3 4 6)) 65)))))
= A

> (string-of-char (dictionary-get-or (string-from-list (list 1 2 3 4)) 70 (dictionary-of (list (Pair (string-from-list (list 1 2 3 4 5)) 67) (Pair (string-from-list (list 1 2 3 4)) 65)))))
= A

A dictionary should return the last value added for a specific key
> (string-of-char (dictionary-get-or (string-empty) 70 (dictionary-set (string-empty) 65 (dictionary-singleton (string-empty) 67))))
= A


dictionary-set should set a value to the empty key
> (string-of-char (dictionary-get-or (string-empty) 66 (dictionary-set (string-empty) 65 (dictionary-empty))))
= A

dictionary-set should add a value with a non-empty key
> (string-of-char (dictionary-get-or (string-of-char 1) 67 (dictionary-singleton (string-of-char 1) 65)))
= A

dictionary-set should keep all values even if an empty key is set
> (string-of-char (dictionary-get-or (string-of-char 1) 67 (dictionary-set (string-empty) 66 (dictionary-singleton (string-of-char 1) 65))))
= A


dictionary-of should add every entry in turn to the dictionary
> (string-of-char (dictionary-get-or (string-empty) 66 (dictionary-of (list (Pair (string-empty) 67) (Pair (string-empty) 65)))))
= A
