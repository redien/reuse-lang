
Should convert an empty string
> s|
= (def data-s () (string-from-list Empty))

Should convert one word
> str|A
= (def data-str () (string-from-list (list 65)))

> s|ABC
= (def data-s () (string-from-list (list 65 66 67)))

Should convert several words
> str|A B C
= (def data-str () (string-from-list (list 65 32 66 32 67)))

Should convert the separator
> s|||
= (def data-s () (string-from-list (list 124 124)))

Should ignore space between separator and identifier
> s |A
= (def data-s () (string-from-list (list 65)))

Should transform separate lines
> a|A
> b|B
= (def data-a () (string-from-list (list 65)))
= (def data-b () (string-from-list (list 66)))
