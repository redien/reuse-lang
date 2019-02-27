
string-concat
> (string-concat (string-empty) (string-empty))
= 

> (string-concat (string-of-char 65) (string-empty))
= A

> (string-concat (string-empty) (string-of-char 65))
= A

> (string-concat (string-of-char 65) (string-of-char 66))
= AB

> (string-concat (string-from-list (list 65 66)) (string-empty))
= AB

> (string-concat (string-from-list (list 65 66 67 68)) (string-empty))
= ABCD

> (string-concat (string-from-list (list 65 66 67 68 69)) (string-empty))
= ABCDE

> (string-concat (string-from-list (list 65 66 67 68 69 70 71 72 73)) (string-empty))
= ABCDEFGHI

> (string-concat (string-empty) (string-from-list (list 65 66)))
= AB

> (string-concat (string-empty) (string-from-list (list 65 66 67 68)))
= ABCD

> (string-concat (string-empty) (string-from-list (list 65 66 67 68 69)))
= ABCDE

> (string-concat (string-empty) (string-from-list (list 65 66 67 68 69 70 71 72 73)))
= ABCDEFGHI

> (string-concat (string-from-list (list 65 66)) (string-from-list (list 67 68)))
= ABCD

> (string-concat (string-from-list (list 65 66 67 68)) (string-from-list (list 69 70 71 72)))
= ABCDEFGH

> (string-concat (string-from-list (list 65 66 67 68 69)) (string-from-list (list 70 71 72 73 74)))
= ABCDEFGHIJ

> (string-concat (string-from-list (list 65 66 67 68 69 70 71 72 73)) (string-from-list (list 74 75 76 77 78 79 80 81 82)))
= ABCDEFGHIJKLMNOPQR

> (string-concat (string-from-list (list-from-range 65 71)) (string-from-list (list-from-range 65 69)))
= ABCDEFABCD

> (string-concat (string-from-list (list-from-range 65 69)) (string-from-list (list-from-range 65 71)))
= ABCDABCDEF


string-size
> (string-of-char (+ 65 (string-size (string-empty))))
= A

> (string-of-char (+ 65 (string-size (string-of-char 1))))
= B

> (string-of-char (+ 65 (string-size (string-from-list (list 1 2)))))
= C

> (string-of-char (+ 65 (string-size (string-from-list (list 1 2 3)))))
= D

> (string-of-char (+ 65 (string-size (string-from-list (list 1 2 3 4)))))
= E

> (string-of-char (+ 65 (string-size (string-from-list (list 1 2 3 4 5)))))
= F

> (string-of-char (+ 65 (string-size (string-from-list (list 1 2 3 4 5 6)))))
= G

> (string-of-char (+ 65 (string-size (string-from-list (list 1 2 3 4 5 6 7)))))
= H

> (string-of-char (+ 65 (string-size (string-from-list (list-from-range 0 20)))))
= U


string-prepend & string-append
> (list-foldl string-append (string-empty) (list-from-range 65 85))
= ABCDEFGHIJKLMNOPQRST

> (list-foldl string-prepend (string-empty) (list-from-range 65 85))
= TSRQPONMLKJIHGFEDCBA

> (list-foldr string-append (string-empty) (list-from-range 65 85))
= TSRQPONMLKJIHGFEDCBA

> (list-foldr string-prepend (string-empty) (list-from-range 65 85))
= ABCDEFGHIJKLMNOPQRST

> (string-append 73 (string-prepend 72 (string-append 71 (string-prepend 70 (string-append 69 (string-prepend 68 (string-append 67 (string-prepend 66 (string-append 65 (string-empty))))))))))
= HFDBACEGI


string-join
> (string-join (string-of-char 44) Empty)
= 

> (string-join (string-of-char 44) (list (string-empty)))
= 

> (string-join (string-of-char 44) (list (string-empty) (string-empty)))
= ,

> (string-join (string-of-char 44) (list (string-empty) (string-of-char 65)))
= ,A

> (string-join (string-of-char 44) (list (string-of-char 65) (string-of-char 66)))
= A,B

> (string-join (string-of-char 44) (list (string-of-char 65) (string-of-char 66) (string-of-char 67)))
= A,B,C

> (string-join (string-of-char 44) (list (string-of-char 65) (string-empty)))
= A,

> (string-join (string-of-char 44) (list (string-of-char 65)))
= A



string-split
> (string-join (string-of-char 44) (string-split 32 (string-empty)))
= 

> (string-join (string-of-char 44) (string-split 32 (string-from-list (list 65))))
= A

> (string-join (string-of-char 44) (string-split 32 (string-from-list (list 65 32 66))))
= A,B

> (string-join (string-of-char 44) (string-split 32 (string-from-list (list 32))))
= ,

> (string-join (string-of-char 44) (string-split 32 (string-from-list (list 32 65))))
= ,A

> (string-join (string-of-char 44) (string-split 32 (string-from-list (list 65 66 32))))
= AB,

> (string-join (string-of-char 44) (string-split 32 (string-from-list (list 65 66 32 32))))
= AB,,

> (string-join (string-of-char 44) (string-split 32 (string-from-list (list 32 32 65 66))))
= ,,AB

> (string-join (string-of-char 44) (string-split 32 (string-from-list (list 65 32 66))))
= A,B

> (string-join (string-of-char 44) (string-split 32 (string-from-list (list 65 32 66 32 67))))
= A,B,C


string-trim-start
> (string-trim-start (string-from-list Empty))
= 

> (string-trim-start (string-from-list (list 65)))
= A

> (string-trim-start (string-from-list (list 65 32)))
= A 

> (string-trim-start (string-from-list (list 32 65)))
= A

> (string-trim-start (string-from-list (list 32)))
= 

> (string-trim-start (string-from-list (list 32 65 32)))
= A 

> (string-trim-start (string-from-list (list 32 65 32 66 32)))
= A B 

> (string-trim-start (string-from-list (list 65 32 32 66)))
= A  B


string-trim-end
> (string-trim-end (string-from-list Empty))
= 

> (string-trim-end (string-from-list (list 65)))
= A

> (string-trim-end (string-from-list (list 65 32)))
= A

> (string-trim-end (string-from-list (list 32 65)))
=  A

> (string-trim-end (string-from-list (list 32)))
= 

> (string-trim-end (string-from-list (list 32 65 32)))
=  A

> (string-trim-end (string-from-list (list 32 65 32 66 32)))
=  A B

> (string-trim-end (string-from-list (list 65 32 32 66)))
= A  B


string-trim
> (string-trim (string-from-list Empty))
= 

> (string-trim (string-from-list (list 65)))
= A

> (string-trim (string-from-list (list 65 32)))
= A

> (string-trim (string-from-list (list 32 65)))
= A

> (string-trim (string-from-list (list 32)))
= 

> (string-trim (string-from-list (list 32 65 32)))
= A

> (string-trim (string-from-list (list 32 65 32 66 32)))
= A B

> (string-trim (string-from-list (list 65 32 32 66)))
= A  B
