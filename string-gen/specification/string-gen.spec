
Should convert an empty string
> s|
= (def data-s () Empty)

Should convert one word
> str|A
= (def data-str () (list 65))

> s|ABC
= (def data-s () (list 65 66 67))

Should convert several words
> str|A B C
= (def data-str () (list 65 32 66 32 67))

Should convert the separator
> s|||
= (def data-s () (list 124 124))

Should ignore space between separator and identifier
> s |A
= (def data-s () (list 65))

Should transform separate lines
> a|A\\nb|B
= (def data-a () (list 65))\\n(def data-b () (list 66))
