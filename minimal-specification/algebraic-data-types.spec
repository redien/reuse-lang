Boolean sum type
| (data myBoolean MyTrue MyFalse)
> (match MyFalse MyTrue 0 MyFalse 1)
= 1

Linked list
| (data (myList a) MyEmpty (MyPair a (myList a)))
> (match (MyPair 2 MyEmpty) MyEmpty 0 (MyPair i _) i)
= 2

Multiple type parameters
| (data singleton Singleton)
| (data (myType a b) (MyConstructor a b))
> (match (MyConstructor 3 Singleton) (MyConstructor i s) i)
= 3

Nested types
| (data (myList a) MyEmpty (MyPair a (myList a)))
| (data (myType a) (MyConstructor (myList (myType a))) (MyValue a))
> (match (MyConstructor (MyPair (MyValue 4) MyEmpty)) (MyConstructor l) (match l MyEmpty 0 (MyPair f r) (match f (MyValue a) a (MyConstructor ignored) 0)))
= 4

Nested types with multiple type parameters
| (data (myType a b) (MyOne (myType a b)) MyNone)
> (match (MyOne (MyOne MyNone)) (MyOne o) 5 MyNone 0)
= 5

Nested match expressions
| (data (first a) (First a))
| (data (second a b) (Second a) (Third b))
> (match (Second (First 6)) (Second a) (match a (First a) a) (Third b) 0)
= 6

Restricting constructor parameters to integers
| (data intType (IntCons int32))
> (match (IntCons 7) (IntCons x) x)
= 7

Restricting constructor parameters to user defined type
| (data userDefined TypeConstant)
| (data otherType (TypeCons userDefined))
> (match (TypeCons TypeConstant) (TypeCons x) (match x TypeConstant 8))
= 8

Restricting constructor parameters to function types
| (data (otherType a) (TypeCons (fun (a) a)))
| (def identity (x) x)
> (match (TypeCons identity) (TypeCons f) (f 9))
= 9

Existential type parameters
| (data (closure (E s) a) (Closure (fun (s) a) s))
| (data (pair a) (Pair a a))
| (def apply (c) (match c (Closure f s) (f s)))
| (def identity (x) x)
| (def first (p) (match p (Pair x y) x))
> (apply (first (Pair (Closure identity 6) (Closure first (Pair 1 2)))))
= 6
