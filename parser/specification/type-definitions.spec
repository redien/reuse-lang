
Should parse the simplest type definition
> (typ a b)
= (typ a b)

Should parse complex type
> (typ (a b) c)
= (typ (a b) c)

Should parse complex constructors
> (typ a (C b))
= (typ a (C b))

Should parse standard types
> (typ (maybe a) (Some a) None)
= (typ (maybe a) (Some a) None)

> (typ (list a) (Cons a (list a)) Empty)
= (typ (list a) (Cons a (list a)) Empty)
