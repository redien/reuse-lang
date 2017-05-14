Boolean sum type
| (data myBoolean MyTrue MyFalse)
> (match MyFalse MyTrue 1 MyFalse 2)
= 2

Linked list
| (data (myList a) MyEmpty (MyPair a (myList a)))
> (match (MyPair 3 MyEmpty) MyEmpty 0 (MyPair i _) i)
= 3

Multiple type parameters
| (data singleton Singleton)
| (data (myType a b) (MyConstructor a b))
> (match (MyConstructor 2 Singleton) (MyConstructor i s) i)
= 2
