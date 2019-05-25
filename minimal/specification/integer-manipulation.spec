Addition
> (+ 1 2)
= 3

Subtraction
> (- 1 2)
= -1

Integers (32-bit signed) should wrap around
> (+ 2147483647 1)
= -2147483648

> (- -2147483648 1)
= 2147483647

> (* 123456 123456)
= -1938485248

Multiplication
> (* 2 3)
= 6

Division
> (/ 4 2)
= 2

Division should round toward zero
> (/ -3 2)
= -1

Remainder
> (% 3 2)
= 1

> (% 2 -3)
= 2

Comparison
> (int32-less-than 3 4 1 0)
= 1

> (int32-less-than 4 2 1 0)
= 0

> (int32-less-than 1 1 1 0)
= 0

Factorial function
| (typ myBool MyTrue MyFalse)
| (def lessThan (a b) (int32-less-than a b MyTrue MyFalse))
| (def factorial2 (n product) (match (lessThan n 2) MyTrue product MyFalse (factorial2 (- n 1) (* product n))))
| (def factorial (n) (factorial2 n 1))
> (factorial 5)
= 120

Should be possible to pass intrinsics as arguments 
| (def f (op) (op 1 2))
> (f +)
= 3

| (def f (op) (op 1 2))
> (f -)
= -1

| (def f (op) (op 1 2))
> (f *)
= 2

| (def f (op) (op 1 2))
> (f /)
= 0

| (def f (op) (op 1 2))
> (f %)
= 1

| (def f (op) (op 1 2))
> (f /)
= 0
