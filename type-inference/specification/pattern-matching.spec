
The type of the expression should be constrained by the type of the constructors
> (typ myType Empty) (def f (x) (match x Empty x))
= myType (fn (myType) myType)

> (typ (myType a) (Some a)) (typ myOtherType Empty) (def f (x) (match x (Some Empty) x _ x))
= (myType A) myOtherType (fn ((myType myOtherType)) (myType myOtherType))
