
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

Should allow integer constants in patterns
> (match 4 4 4 _ 0)
= 4

> (match 5 1 0 5 5 _ 0)
= 5

| (typ (maybe a) (Some a) None)
> (match (Some 6) (Some 6) 6 _ 0)
= 6

| (typ (maybe a) (Some a) None)
> (match (Some -7) (Some -7) -7 _ 0)
= -7

