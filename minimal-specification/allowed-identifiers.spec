
Should allow defining boolean type
| (data boolean True False)
> (match False True 1 False 2)
= 2

| (data bool True False)
> (match False True 1 False 2)
= 2

Should allow defining types with name type
| (data type A)
> (match A A 3)
= 3

Should allow defining maybe type
| (data (maybe a) None (Some a))
> (match (Some 1) (Some x) x None 0)
= 1

Should allow defining functions with non-latin characters
| (def < (a b) a)
> (< 3 2)
= 3

| (def 日本語 (a) a)
> (日本語 42)
= 42
