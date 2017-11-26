
Should quote symbols with one character
> (match (quote a) (Atom (Cons x Empty)) x else 0)
= 97

Should quote symbols with several characters
> (match (quote abc) (Atom (Cons _ (Cons b (Cons __ Empty)))) b else 0)
= 98

Should quote an empty list
> (match (quote ()) (List Empty) 1 else 0)
= 1

Should quote a list with one entry
> (match (quote (a)) (List (Cons (Atom (Cons x Empty)) Empty)) x else 0)
= 97 

