
A dictionary should be able to add and retrieve a value
> (list (dictionary-get-or Empty 66 (dictionary-singleton Empty 65)))
= A

> (list (dictionary-get-or (list 1) 70 (dictionary-singleton (list 1) 65)))
= A

> (list (dictionary-get-or (list 1) 70 (dictionary-of (list (Pair (list 99) 67) (Pair (list 98) 66) (Pair (list 1) 65)))))
= A

> (list (dictionary-get-or (list 1 2) 70 (dictionary-of (list (Pair (list 1 2) 65) (Pair (list 2 2) 67)))))
= A

> (list (dictionary-get-or (list 1) 70 (dictionary-of (list (Pair (list 99) 67) (Pair (list 1) 65) (Pair (list 98) 66)))))
= A

> (list (dictionary-get-or (list 1) 70 (dictionary-of (list (Pair (list 1) 65) (Pair (list 99) 67) (Pair (list 98) 66)))))
= A

> (list (dictionary-get-or (list 1 2) 70 (dictionary-of (list (Pair (list 1) 67) (Pair (list 1 2) 65)))))
= A

> (list (dictionary-get-or (list 1 2 3 4 6) 70 (dictionary-of (list (Pair (list 1 2 3 4 5) 67) (Pair (list 1 2 3 4 6) 65)))))
= A

> (list (dictionary-get-or (list 1 2 3 4) 70 (dictionary-of (list (Pair (list 1 2 3 4 5) 67) (Pair (list 1 2 3 4) 65)))))
= A

A dictionary should return the last value added for a specific key
> (list (dictionary-get-or Empty 70 (dictionary-set Empty 65 (dictionary-singleton Empty 67))))
= A


dictionary-set should set a value to the empty key
> (list (dictionary-get-or Empty 66 (dictionary-set Empty 65 (dictionary-empty))))
= A

dictionary-set should add a value with a non-empty key
> (list (dictionary-get-or (list 1) 67 (dictionary-singleton (list 1) 65)))
= A

dictionary-set should keep all values even if an empty key is set
> (list (dictionary-get-or (list 1) 67 (dictionary-set Empty 66 (dictionary-singleton (list 1) 65))))
= A


dictionary-of should add every entry in turn to the dictionary
> (list (dictionary-get-or Empty 66 (dictionary-of (list (Pair Empty 67) (Pair Empty 65)))))
= A


dictionary-entries should return the list of entries in the dictionary
> (list (list-foldl + 0 (list-map pair-right (dictionary-entries (dictionary-of (list (Pair (list 1) 60) (Pair (list 2) 7)))))))
= C

dictionary-entries should only return the last set value for a given key
> (list (list-foldl + 60 (list-map pair-right (dictionary-entries (dictionary-of (list (Pair Empty 5) (Pair Empty 7)))))))
= C

dictionary-entries of an empty dictionary should give the empty list
> (list-map pair-right (dictionary-entries (dictionary-empty)))
= 
