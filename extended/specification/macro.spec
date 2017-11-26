
Defining a string macro
| (macro str (expressions) (match expressions (List (Cons (Atom string) _)) string else Empty))
> (match (str a) (Cons x Empty) x else 0)
= 97

| (macro str (expressions) (match expressions (List (Cons (Atom string) _)) string else Empty))
> (match (str b) (Cons x Empty) x else 0)
= 98

