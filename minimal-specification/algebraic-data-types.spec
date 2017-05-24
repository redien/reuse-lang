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
