
Should allow nesting constructors
| (data (single a) (Single a))
| (data (maybe a) (Some a) None)
> (match (Single (Some 1)) (Single (Some x)) x _ 0)
= 1

| (data (either a) (First a) (Second a))
| (data (maybe a) (Some a) None)
> (match (Second (Some 2)) (First (Some x)) 0 (Second (Some x)) x _ 0)
= 2

| (data (list a) (Cons a (list a)) Empty)
> (match (Cons 2 (Cons 3 Empty)) (Cons _ (Cons y Empty)) y _ 0)
= 3
