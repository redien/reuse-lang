
list-foldr
> (string-from-list (list-foldr list-cons Empty (list 65 66 67)))
= ABC

list-foldl
> (string-from-list (list-foldl list-cons Empty (list 65 66 67)))
= CBA


list-zip
> (string-from-list (list-map (pair-map +) (list-zip (list 65 65 65) (list 0 1 2))))
= ABC

> (string-from-list (list-map (pair-map +) (list-zip (list 65 65) (list 0 1 2))))
= AB

> (string-from-list (list-map (pair-map +) (list-zip (list 65 65 65) (list 0 1))))
= AB

> (string-from-list (list-map (pair-map +) (list-zip Empty Empty)))
= 


list-pairs
> (string-from-list (list-map (pair-map +) (list-pairs Empty)))
= 

> (string-from-list (list-map (pair-map +) (list-pairs (list 65))))
= 

> (string-from-list (list-map (pair-map +) (list-pairs (list 65 1))))
= B

> (string-from-list (list-map (pair-map +) (list-pairs (list 65 1 1))))
= B

> (string-from-list (list-map (pair-map +) (list-pairs (list 65 2 60 8))))
= CD
