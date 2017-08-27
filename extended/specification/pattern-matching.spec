
Should allow nesting constructors
| (typ (single a) (Single a))
| (typ (maybe a) (Some a) None)
> (match (Single (Some 1)) (Single (Some x)) x _ 0)
= 1

| (typ (either a) (First a) (Second a))
| (typ (maybe a) (Some a) None)
> (match (Second (Some 2)) (First (Some x)) 0 (Second (Some x)) x _ 0)
= 2

| (typ (list a) (Cons a (list a)) Empty)
> (match (Cons 2 (Cons 3 Empty)) (Cons _ (Cons y Empty)) y _ 0)
= 3
