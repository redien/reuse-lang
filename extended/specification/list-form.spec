
Has list-form that can create an empty list
> (match (list) Empty 1 x 0)
= 1

Has list-form that can create a singleton-list
> (match (list 2) (Cons x Empty) x x 0)
= 2

Has list-form that can create a n-ary list
> (match (list 3 4) (Cons a (Cons b Empty)) (- b a) x 0)
= 1

