
list-from-range
> (string-from-list (list-map (+ 65) (list-from-range 0 0)))
= 

> (string-from-list (list-map (+ 65) (list-from-range 0 1)))
= A

> (string-from-list (list-map (+ 65) (list-from-range 0 10)))
= ABCDEFGHIJ


list-foldr
> (string-from-list (list-foldr list-cons Empty (list 65 66 67)))
= ABC

> (string-from-list (list-foldr list-cons Empty (list 65 66 67 68 69 70 71 72 73)))
= ABCDEFGHI

list-foldl
> (string-from-list (list-foldl list-cons Empty (list 65 66 67)))
= CBA

> (string-from-list (list-foldl list-cons Empty (list 65 66 67 68 69 70 71 72 73)))
= IHGFEDCBA

> (string-from-boolean (= 1575 (list-foldl + 0 (list 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85))))
= True


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


list-concat
> (string-from-list (list-concat (list-empty) (list-empty)))
= 

> (string-from-list (list-concat (list 65) (list-empty)))
= A

> (string-from-list (list-concat (list-empty) (list 65)))
= A

> (string-from-list (list-concat (list 65) (list 66)))
= AB

> (string-from-list (list-concat (list 65 66) (list-empty)))
= AB

> (string-from-list (list-concat (list 65 66 67 68) (list-empty)))
= ABCD

> (string-from-list (list-concat (list 65 66 67 68 69) (list-empty)))
= ABCDE

> (string-from-list (list-concat (list 65 66 67 68 69 70 71 72 73) (list-empty)))
= ABCDEFGHI

> (string-from-list (list-concat (list-empty) (list 65 66)))
= AB

> (string-from-list (list-concat (list-empty) (list 65 66 67 68)))
= ABCD

> (string-from-list (list-concat (list-empty) (list 65 66 67 68 69)))
= ABCDE

> (string-from-list (list-concat (list-empty) (list 65 66 67 68 69 70 71 72 73)))
= ABCDEFGHI

> (string-from-list (list-concat (list 65 66) (list 67 68)))
= ABCD

> (string-from-list (list-concat (list 65 66 67 68) (list 69 70 71 72)))
= ABCDEFGH

> (string-from-list (list-concat (list 65 66 67 68 69) (list 70 71 72 73 74)))
= ABCDEFGHIJ

> (string-from-list (list-concat (list 65 66 67 68 69 70 71 72) (list 73 74 75 76 77 78 79 80)))
= ABCDEFGHIJKLMNOP

> (string-from-list (list-concat (list 65 66 67 68 69 70 71 72 73) (list 74 75 76 77 78 79 80 81 82)))
= ABCDEFGHIJKLMNOPQR

> (string-from-list (list-concat (list 65 66 67 68 69 70 71 72 73 74) (list 75 76 77 78 79 80 81 82 83 84)))
= ABCDEFGHIJKLMNOPQRST

> (string-from-list (list-concat (list-from-range 65 71) (list-from-range 65 69)))
= ABCDEFABCD

> (string-from-list (list-concat (list-from-range 65 69) (list-from-range 65 71)))
= ABCDABCDEF
