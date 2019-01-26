
list-foldr
> (list-foldr list-cons Empty (list 65 66 67))
= ABC

list-foldl
> (list-foldl list-cons Empty (list 65 66 67))
= CBA


list-zip
| (def sum (pairs) (list-map (fn (pair) (match pair (Pair a b) (+ a b))) pairs))
> (sum (list-zip (list 65 65 65) (list 0 1 2)))
= ABC

| (def sum (pairs) (list-map (fn (pair) (match pair (Pair a b) (+ a b))) pairs))
> (sum (list-zip (list 65 65) (list 0 1 2)))
= AB

| (def sum (pairs) (list-map (fn (pair) (match pair (Pair a b) (+ a b))) pairs))
> (sum (list-zip (list 65 65 65) (list 0 1)))
= AB

| (def sum (pairs) (list-map (fn (pair) (match pair (Pair a b) (+ a b))) pairs))
> (sum (list-zip Empty Empty))
= 
