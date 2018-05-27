
Should parse the simplest type definition
> (typ a b)
= (typ a b)

Should parse complex type
> (typ (a b) c)
= (typ (a b) c)

Should parse complex constructors
> (typ a (C b))
= (typ a (C b))

Should parse function types
> (typ (fun a) (Fun (fn ((list a)) a)))
= (typ (fun a) (Fun (fn ((list a)) a)))

Should parse standard types
> (typ (maybe a) (Some a) None)
= (typ (maybe a) (Some a) None)

> (typ (list a) (Cons a (list a)) Empty)
= (typ (list a) (Cons a (list a)) Empty)

Should parse existential types
> (typ (closure (exists s) a) (Closure (fn (s) a) s))
= (typ (closure (exists s) a) (Closure (fn (s) a) s))

Should parse constructor expressions
> (def _ () (Constructor x))
= (def _ () (Constructor x))
