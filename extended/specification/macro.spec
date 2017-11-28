
Defining an identity macro
| (macro identity (atoms) (match atoms (List (Cons x)) x else (Atom Empty)))
> (identity 1)
= 1

