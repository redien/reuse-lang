
Should parse list special form
> (def _ () (list))
= (def _ () (list))

> (def _ () (list 1))
= (def _ () (list 1))

> (def _ () (list 1 2))
= (def _ () (list 1 2))

> (def _ () (list 1 2 3))
= (def _ () (list 1 2 3))

> (def _ (x) (list x))
= (def _ (x) (list x))
