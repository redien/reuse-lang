
list-foldr
> (list-foldr list-cons Empty (list 65 66 67))
= ABC

list-foldl
> (list-foldl list-cons Empty (list 65 66 67))
= CBA


list-zip
> (list-map (pair-map +) (list-zip (list 65 65 65) (list 0 1 2)))
= ABC

> (list-map (pair-map +) (list-zip (list 65 65) (list 0 1 2)))
= AB

> (list-map (pair-map +) (list-zip (list 65 65 65) (list 0 1)))
= AB

> (list-map (pair-map +) (list-zip Empty Empty))
= 


list-pairs
> (list-map (pair-map +) (list-pairs Empty))
= 

> (list-map (pair-map +) (list-pairs (list 65)))
= 

> (list-map (pair-map +) (list-pairs (list 65 1)))
= B

> (list-map (pair-map +) (list-pairs (list 65 1 1)))
= B

> (list-map (pair-map +) (list-pairs (list 65 2 60 8)))
= CD
