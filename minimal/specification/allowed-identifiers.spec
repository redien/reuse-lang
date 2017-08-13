
Should allow defining boolean type
| (data boolean True False)
> (match True True 1 False 2)
= 1

| (data bool True False)
> (match False True 1 False 2)
= 2

Should allow defining types with name type
| (data type A)
> (match A A 3)
= 3

Should allow defining maybe type
| (data (maybe a) None (Some a))
> (match (Some 4) (Some x) x None 0)
= 4

Should allow defining functions with non-latin characters
| (def < (a b) a)
> (< 5 2)
= 5

| (def 日本語 (a) a)
> (日本語 6)
= 6

Should allow defining variables with non-latin characters
| (data (myType a) (MyPair a))
> (match (MyPair 7) (MyPair 日本語) 日本語)
= 7

Should allow defining constructors with non-latin characters
| (data (myType a) (日本語 a))
> (match (日本語 8) (日本語 x) x)
= 8
