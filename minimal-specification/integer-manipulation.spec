Addition
> (+ 1 2)
= 3

Subtraction
> (- 1 2)
= -1

Multiplication
> (* 2 3)
= 6

Division
> (/ 4 2)
= 2

Remainder
> (% 3 2)
= 1

Comparison
> (int32-compare 3 1 4 0)
= 1

> (int32-compare 4 1 2 0)
= 0

> (int32-compare 1 1 1 0)
= 0

Factorial function
| (data myBool MyTrue MyFalse)
| (define lessThan (a b) (int32-compare a MyTrue b MyFalse))
| (define factorial2 (n product) (match (lessThan n 2) MyTrue product MyFalse (factorial2 (- n 1) (* product n))))
| (define factorial (n) (factorial2 n 1))
> (factorial 5)
= 120
