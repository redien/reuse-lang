
string-join
> (string-join (list 44) Empty)
= 

> (string-join (list 44) (list Empty))
= 

> (string-join (list 44) (list Empty Empty))
= ,

> (string-join (list 44) (list Empty (list 65)))
= ,A

> (string-join (list 44) (list (list 65) (list 66)))
= A,B

> (string-join (list 44) (list (list 65) (list 66) (list 67)))
= A,B,C

> (string-join (list 44) (list (list 65) Empty))
= A,

> (string-join (list 44) (list (list 65)))
= A



string-split
> (string-join (list 44) (string-split 32 Empty))
= 

> (string-join (list 44) (string-split 32 (list 65)))
= A

> (string-join (list 44) (string-split 32 (list 65 32 66)))
= A,B

> (string-join (list 44) (string-split 32 (list 32)))
= ,

> (string-join (list 44) (string-split 32 (list 32 65)))
= ,A

> (string-join (list 44) (string-split 32 (list 65 66 32)))
= AB,

> (string-join (list 44) (string-split 32 (list 65 66 32 32)))
= AB,,

> (string-join (list 44) (string-split 32 (list 32 32 65 66)))
= ,,AB

> (string-join (list 44) (string-split 32 (list 65 32 66)))
= A,B

> (string-join (list 44) (string-split 32 (list 65 32 66 32 67)))
= A,B,C


string-trim-start
> (string-trim-start Empty)
= 

> (string-trim-start (list 65))
= A

> (string-trim-start (list 65 32))
= A 

> (string-trim-start (list 32 65))
= A

> (string-trim-start (list 32))
= 

> (string-trim-start (list 32 65 32))
= A 

> (string-trim-start (list 32 65 32 66 32))
= A B 

> (string-trim-start (list 65 32 32 66))
= A  B


string-trim-end
> (string-trim-end Empty)
= 

> (string-trim-end (list 65))
= A

> (string-trim-end (list 65 32))
= A

> (string-trim-end (list 32 65))
=  A

> (string-trim-end (list 32))
= 

> (string-trim-end (list 32 65 32))
=  A

> (string-trim-end (list 32 65 32 66 32))
=  A B

> (string-trim-end (list 65 32 32 66))
= A  B


string-trim
> (string-trim Empty)
= 

> (string-trim (list 65))
= A

> (string-trim (list 65 32))
= A

> (string-trim (list 32 65))
= A

> (string-trim (list 32))
= 

> (string-trim (list 32 65 32))
= A

> (string-trim (list 32 65 32 66 32))
= A B

> (string-trim (list 65 32 32 66))
= A  B
