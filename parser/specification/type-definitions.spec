
Should parse the simplest type definition
> (typ a b)
= (typ a b)

Should parse public type definitions
> (pub typ a b)
= (pub typ a b)

Should parse complex constructors
> (typ a (C a))
= (typ a (C a))

Should parse universal type parameters
> (typ (a b) c)
= (typ (a b) c)

> (typ (a b) (c b))
= (typ (a b) (c b))

Should parse existential type parameters
> (typ (a (exists b)) c)
= (typ (a (exists b)) c)

> (typ (a (exists b)) (c b))
= (typ (a (exists b)) (c b))

Should parse function types
> (typ f (Fun (fn (f) f)))
= (typ f (Fun (fn (f) f)))

Should parse constructor expressions
> (typ a (Constructor a)) (def _ () (Constructor 1))
= (typ a (Constructor a)) (def _ () (Constructor 1))

> (typ a Constructor) (def _ () Constructor)
= (typ a Constructor) (def _ () Constructor)

Should parse standard types
> (typ (maybe a) (Some a) None)
= (typ (maybe a) (Some a) None)

> (typ (list a) (Cons a (list a)) Empty)
= (typ (list a) (Cons a (list a)) Empty)

Should return an error when missing constructors
> (typ a)
? TypeDefinitionMissingConstructors
