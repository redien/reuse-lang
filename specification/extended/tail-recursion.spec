
Should optimize tail-recursive calls to use constant stack space
| (def count-down (x) (match (int32-less-than 0 x 1 0) 1 (count-down (- x 1)) 0 0))
> (count-down 10000)
= 0

Should optimize tail-recursive calls with multiple arguments
| (def count-up (x y) (match (int32-less-than 0 x 1 0) 1 (count-up (- x 1) (+ y 1)) 0 y))
> (count-up 10000 0)
= 10000
