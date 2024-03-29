
Should optimize tail-recursive calls to use constant stack space
| (def count-down (x) (match (int32-less-than 0 x 1 0) 1 (count-down (- x 1)) 0 0))
> (count-down 10000)
= 0

Should optimize tail-recursive calls with multiple arguments
| (def count-up (x y) (match (int32-less-than 0 x 1 0) 1 (count-up (- x 1) (+ y 1)) 0 y))
> (count-up 10000 0)
= 10000

Should not optimize call if shadowed by function argument
| (def f (x f) (f x))
> (f 1 (fn (x) x))
= 1

Should not optimize call if the function name was shadowed by a pattern matching capture
| (typ (pair a b) (Pair a b))
| (def f (x) (match x (Pair f a) (f a)))
> (f (Pair (fn (x) x) 1))
= 1

Should not optimize call if the function name was shadowed by a nested pattern matching capture
| (typ (pair a b) (Pair a b))
| (def f (x) (match x (Pair (Pair f b) a) (f a)))
> (f (Pair (Pair (fn (x) x) 0) 1))
= 1

Should optimize the correct call if one is shadowed but one is a tail call
| (typ (t a b) (A a b) (B a b))
| (def f (x) (match x (A f a) (f a) (B _ a) (f (A (fn (x) x) a))))
> (f (A (fn (x) x) 1))
= 1

Should be able to return lambdas from a tail-recursive function
| (def f (x) (match x 1 (fn () 2) 0 (f 1)))
> ((f 0))
= 2

Nested calls should work even if one is in tail position
| (typ tree (Tree tree tree) (Leaf int32))
| (def foldl (f accumulator tree) (match tree (Leaf x) (f x accumulator) (Tree a b) (foldl f (foldl f accumulator b) a)))
> (foldl + 1 (Tree (Tree (Leaf 3) (Tree (Leaf 6) (Leaf 6))) (Leaf 26)))
= 42
