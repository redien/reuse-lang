Boolean sum type
| (typ myBoolean MyTrue MyFalse)
> (match MyFalse MyTrue 0 MyFalse 1)
= 1

Linked list
| (typ (myList a) MyEmpty (MyPair a (myList a)))
> (match (MyPair 2 MyEmpty) MyEmpty 0 (MyPair i _) i)
= 2

Multiple type parameters
| (typ singleton Singleton)
| (typ (myType a b) (MyConstructor a b))
> (match (MyConstructor 3 Singleton) (MyConstructor i s) i)
= 3

Nested types
| (typ (myList a) MyEmpty (MyPair a (myList a)))
| (typ (myType a) (MyConstructor (myList (myType a))) (MyValue a))
> (match (MyConstructor (MyPair (MyValue 4) MyEmpty)) (MyConstructor l) (match l MyEmpty 0 (MyPair f r) (match f (MyValue a) a (MyConstructor ignored) 0)))
= 4

Nested types with multiple type parameters
| (typ (myType a b) (MyOne (myType a b)) MyNone)
> (match (MyOne (MyOne MyNone)) (MyOne o) 5 MyNone 0)
= 5

Nested match expressions
| (typ (first a) (First a))
| (typ (second a b) (Second a) (Third b))
> (match (Second (First 6)) (Second a) (match a (First a) a) (Third b) 0)
= 6

Restricting constructor parameters to integers
| (typ intType (IntCons int32))
> (match (IntCons 7) (IntCons x) x)
= 7

Restricting constructor parameters to user defined type
| (typ userDefined TypeConstant)
| (typ otherType (TypeCons userDefined))
> (match (TypeCons TypeConstant) (TypeCons x) (match x TypeConstant 8))
= 8

Restricting constructor parameters to function types
| (typ (otherType a) (TypeCons (fn (a) a)))
| (def identity (x) x)
> (match (TypeCons identity) (TypeCons f) (f 9))
= 9

Existential type parameters
| (typ (closure (exists s) a) (Closure (fn (s) a) s))
| (typ (pair a) (Pair a a))
| (def apply (c) (match c (Closure f s) (f s)))
| (def identity (x) x)
| (def first (p) (match p (Pair x y) x))
> (apply (first (Pair (Closure identity 10) (Closure first (Pair 1 2)))))
= 10

Universal type parameters
| (typ (universal a) (Universal a))
| (def destruct (u) (match u (Universal a) a))
> (destruct (destruct (Universal (Universal 11))))
= 11
