
Should infer the type of a new type definition
> (typ myType Empty)
= myType


Should infer types with type variables
> (typ (myType x) (Something x))
= (myType A)

> (typ (myType x y) (Something x y))
= (myType A B)


Should infer types with existential type variables
> (typ (myType (exists x)) (Something x))
= (myType (exists A))


Should add constructor types to context
> (typ myType Empty) (def f () Empty)
= myType (fn () myType)

> (typ myType First Second) (def f () Second)
= myType (fn () myType)

> (typ (myType a) (Empty a)) (def f () (Empty 1))
= (myType A) (fn () (myType int32))
