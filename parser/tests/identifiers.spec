
Should parse identifiers
> (def _ (f) f)
= (def _ (f) f)

> (def _ (identifier) identifier)
= (def _ (identifier) identifier)

Should give an error when an identifier is not defined
> (def foo () x)
? ErrorNotDefined: x

> (def foo () (x 1))
? ErrorNotDefined: x

> (def foo (_) (foo x))
? ErrorNotDefined: x

> (def foo () (match x 1 0))
? ErrorNotDefined: x

> (def foo () (match 1 0 x))
? ErrorNotDefined: x

> (def foo () (fn () x))
? ErrorNotDefined: x

> (typ foo (A x))
? ErrorNotDefined: x

> (typ b B) (typ foo (A (x b)))
? ErrorNotDefined: x

> (typ (b a) (B a)) (typ foo (A (b x)))
? ErrorNotDefined: x
