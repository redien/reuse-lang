
Construct arrays from a single int32 value
> (array-foldl + 0 (ArrayOfInt32 1))
= 1

> (array-foldl + 0 (ArrayOfInt32 -42))
= -42


Should apply operations in the right order for a left-fold
> (array-foldl / 12 (ArrayOfInt32 2))
= 6


Concatenating two arrays together
> (array-foldl + 0 (ArrayConcat (ArrayOfInt32 1) (ArrayOfInt32 1)))
= 2

> (array-foldl + 0 (ArrayConcat (ArrayOfInt32 -1) (ArrayOfInt32 1)))
= 0

> (array-foldl + 0 (ArrayConcat (ArrayOfInt32 2) (ArrayConcat (ArrayOfInt32 1) (ArrayOfInt32 1))))
= 4

> (array-foldl + 0 (ArrayConcat (ArrayOfInt32 1) (ArrayConcat (ArrayOfInt32 2) (ArrayOfInt32 1))))
= 4

> (array-foldl + 0 (ArrayConcat (ArrayOfInt32 1) (ArrayConcat (ArrayOfInt32 1) (ArrayOfInt32 2))))
= 4


Construct arrays of arbitrary shape
> (array-foldl + 0 (ArrayGenerate (ArrayOfInt32 42) 1))
= 42

| (def shape () (ArrayConcat (ArrayOfInt32 2) (ArrayOfInt32 2)))
> (array-foldl + 0 (ArrayGenerate (shape) 1))
= 4

| (def shape () (ArrayConcat (ArrayOfInt32 2) (ArrayConcat (ArrayOfInt32 3) (ArrayOfInt32 4))))
> (array-foldl + 0 (ArrayGenerate (shape) 1))
= 24


Generate should remove negative dimensions
> (array-foldl + 0 (ArrayGenerate (ArrayOfInt32 -1) 1))
= 0

| (def shape () (ArrayConcat (ArrayOfInt32 -2) (ArrayOfInt32 -2)))
> (array-foldl + 0 (ArrayGenerate (shape) 1))
= 0

| (def shape () (ArrayConcat (ArrayOfInt32 2) (ArrayOfInt32 -3)))
> (array-foldl + 0 (ArrayGenerate (shape) 1))
= 2

| (def shape () (ArrayConcat (ArrayOfInt32 -3) (ArrayOfInt32 2)))
> (array-foldl + 0 (ArrayGenerate (shape) 1))
= 2

> (array-foldl + 0 (ArrayShape (ArrayGenerate (ArrayOfInt32 -1) 1)))
= 0

> (array-foldl + 0 (ArrayShape (ArrayShape (ArrayGenerate (ArrayOfInt32 -1) 1))))
= 0

> (array-foldl + 0 (ArrayShape (ArrayShape (ArrayShape (ArrayGenerate (ArrayOfInt32 -1) 1)))))
= 1


Should return the shape of the generated array
> (array-foldl + 0 (ArrayShape (ArrayGenerate (ArrayOfInt32 42) 0)))
= 42

| (def shape () (ArrayConcat (ArrayOfInt32 2) (ArrayOfInt32 2)))
> (array-foldl + 0 (ArrayShape (ArrayGenerate (shape) 0)))
= 4

| (def shape () (ArrayConcat (ArrayOfInt32 2) (ArrayConcat (ArrayOfInt32 3) (ArrayOfInt32 4))))
> (array-foldl + 0 (ArrayShape (ArrayGenerate (shape) 0)))
= 9


The shape of a shape should be a 1-D array with an element per dimension
> (array-foldl + 0 (ArrayShape (ArrayShape (ArrayGenerate (ArrayOfInt32 42) 0))))
= 1

| (def shape () (ArrayConcat (ArrayOfInt32 2) (ArrayOfInt32 2)))
> (array-foldl + 0 (ArrayShape (ArrayShape (ArrayGenerate (shape) 0))))
= 2


Should perform a partial sum over a 1-D array
> (array-foldl + 0 (ArrayScan ArrayAdd 0 (ArrayGenerate (ArrayOfInt32 5) 1)))
= 15


Should perform a partial product over a 1-D array
> (array-foldl + 0 (ArrayScan ArrayMultiply 1 (ArrayScan ArrayAdd 0 (ArrayGenerate (ArrayOfInt32 5) 1))))
= 153


Add
> (array-foldl + 0 (ArrayMap ArrayAdd (ArrayOfInt32 0) (ArrayOfInt32 0)))
= 0

> (array-foldl + 0 (ArrayMap ArrayAdd (ArrayOfInt32 0) (ArrayOfInt32 1)))
= 1

> (array-foldl + 0 (ArrayMap ArrayAdd (ArrayOfInt32 1) (ArrayOfInt32 0)))
= 1

> (array-foldl + 0 (ArrayMap ArrayAdd (ArrayOfInt32 1) (ArrayOfInt32 1)))
= 2

> (array-foldl + 0 (ArrayMap ArrayAdd (ArrayOfInt32 1) (ArrayOfInt32 2147483647)))
= -2147483648


Subtract
> (array-foldl + 0 (ArrayMap ArraySubtract (ArrayOfInt32 0) (ArrayOfInt32 0)))
= 0

> (array-foldl + 0 (ArrayMap ArraySubtract (ArrayOfInt32 0) (ArrayOfInt32 1)))
= -1

> (array-foldl + 0 (ArrayMap ArraySubtract (ArrayOfInt32 1) (ArrayOfInt32 0)))
= 1

> (array-foldl + 0 (ArrayMap ArraySubtract (ArrayOfInt32 1) (ArrayOfInt32 1)))
= 0

> (array-foldl + 0 (ArrayMap ArraySubtract (ArrayOfInt32 -2147483648) (ArrayOfInt32 1)))
= 2147483647


Multiply
> (array-foldl + 0 (ArrayMap ArrayMultiply (ArrayOfInt32 0) (ArrayOfInt32 0)))
= 0

> (array-foldl + 0 (ArrayMap ArrayMultiply (ArrayOfInt32 0) (ArrayOfInt32 1)))
= 0

> (array-foldl + 0 (ArrayMap ArrayMultiply (ArrayOfInt32 1) (ArrayOfInt32 0)))
= 0

> (array-foldl + 0 (ArrayMap ArrayMultiply (ArrayOfInt32 1) (ArrayOfInt32 1)))
= 1

> (array-foldl + 0 (ArrayMap ArrayMultiply (ArrayOfInt32 1) (ArrayOfInt32 2)))
= 2

> (array-foldl + 0 (ArrayMap ArrayMultiply (ArrayOfInt32 123456) (ArrayOfInt32 123456)))
= -1938485248


Divide
> (array-foldl + 0 (ArrayMap ArrayDivide (ArrayOfInt32 0) (ArrayOfInt32 0)))
= 0

> (array-foldl + 0 (ArrayMap ArrayDivide (ArrayOfInt32 0) (ArrayOfInt32 1)))
= 0

> (array-foldl + 0 (ArrayMap ArrayDivide (ArrayOfInt32 1) (ArrayOfInt32 0)))
= 0

> (array-foldl + 0 (ArrayMap ArrayDivide (ArrayOfInt32 1) (ArrayOfInt32 1)))
= 1

> (array-foldl + 0 (ArrayMap ArrayDivide (ArrayOfInt32 2) (ArrayOfInt32 2)))
= 1

> (array-foldl + 0 (ArrayMap ArrayDivide (ArrayOfInt32 3) (ArrayOfInt32 2)))
= 1

> (array-foldl + 0 (ArrayMap ArrayDivide (ArrayOfInt32 4) (ArrayOfInt32 2)))
= 2


Equal
> (array-foldl + 0 (ArrayMap ArrayEqual (ArrayOfInt32 1) (ArrayOfInt32 2)))
= 0

> (array-foldl + 0 (ArrayMap ArrayEqual (ArrayOfInt32 2) (ArrayOfInt32 2)))
= 1

> (array-foldl + 0 (ArrayMap ArrayEqual (ArrayOfInt32 3) (ArrayOfInt32 2)))
= 0


Not Equal
> (array-foldl + 0 (ArrayMap ArrayNotEqual (ArrayOfInt32 1) (ArrayOfInt32 2)))
= 1

> (array-foldl + 0 (ArrayMap ArrayNotEqual (ArrayOfInt32 2) (ArrayOfInt32 2)))
= 0

> (array-foldl + 0 (ArrayMap ArrayNotEqual (ArrayOfInt32 3) (ArrayOfInt32 2)))
= 1


Greater than
> (array-foldl + 0 (ArrayMap ArrayGreaterThan (ArrayOfInt32 1) (ArrayOfInt32 2)))
= 0

> (array-foldl + 0 (ArrayMap ArrayGreaterThan (ArrayOfInt32 2) (ArrayOfInt32 2)))
= 0

> (array-foldl + 0 (ArrayMap ArrayGreaterThan (ArrayOfInt32 3) (ArrayOfInt32 2)))
= 1


Greater than or equal
> (array-foldl + 0 (ArrayMap ArrayGreaterThanEqual (ArrayOfInt32 1) (ArrayOfInt32 2)))
= 0

> (array-foldl + 0 (ArrayMap ArrayGreaterThanEqual (ArrayOfInt32 2) (ArrayOfInt32 2)))
= 1

> (array-foldl + 0 (ArrayMap ArrayGreaterThanEqual (ArrayOfInt32 3) (ArrayOfInt32 2)))
= 1


Less than
> (array-foldl + 0 (ArrayMap ArrayLessThan (ArrayOfInt32 1) (ArrayOfInt32 2)))
= 1

> (array-foldl + 0 (ArrayMap ArrayLessThan (ArrayOfInt32 2) (ArrayOfInt32 2)))
= 0

> (array-foldl + 0 (ArrayMap ArrayLessThan (ArrayOfInt32 3) (ArrayOfInt32 2)))
= 0


Less than or equal
> (array-foldl + 0 (ArrayMap ArrayLessThanEqual (ArrayOfInt32 1) (ArrayOfInt32 2)))
= 1

> (array-foldl + 0 (ArrayMap ArrayLessThanEqual (ArrayOfInt32 2) (ArrayOfInt32 2)))
= 1

> (array-foldl + 0 (ArrayMap ArrayLessThanEqual (ArrayOfInt32 3) (ArrayOfInt32 2)))
= 0


AND
> (array-foldl + 0 (ArrayMap ArrayAnd (ArrayOfInt32 0) (ArrayOfInt32 1)))
= 0

> (array-foldl + 0 (ArrayMap ArrayAnd (ArrayOfInt32 1) (ArrayOfInt32 0)))
= 0

> (array-foldl + 0 (ArrayMap ArrayAnd (ArrayOfInt32 1) (ArrayOfInt32 1)))
= 1

> (array-foldl + 0 (ArrayMap ArrayAnd (ArrayOfInt32 4) (ArrayOfInt32 7)))
= 4

> (array-foldl + 0 (ArrayMap ArrayAnd (ArrayOfInt32 4) (ArrayOfInt32 10)))
= 0


OR
> (array-foldl + 0 (ArrayMap ArrayOr (ArrayOfInt32 0) (ArrayOfInt32 1)))
= 1

> (array-foldl + 0 (ArrayMap ArrayOr (ArrayOfInt32 1) (ArrayOfInt32 0)))
= 1

> (array-foldl + 0 (ArrayMap ArrayOr (ArrayOfInt32 1) (ArrayOfInt32 1)))
= 1

> (array-foldl + 0 (ArrayMap ArrayOr (ArrayOfInt32 4) (ArrayOfInt32 7)))
= 7

> (array-foldl + 0 (ArrayMap ArrayOr (ArrayOfInt32 4) (ArrayOfInt32 10)))
= 14


XOR
> (array-foldl + 0 (ArrayMap ArrayXor (ArrayOfInt32 0) (ArrayOfInt32 1)))
= 1

> (array-foldl + 0 (ArrayMap ArrayXor (ArrayOfInt32 1) (ArrayOfInt32 0)))
= 1

> (array-foldl + 0 (ArrayMap ArrayXor (ArrayOfInt32 1) (ArrayOfInt32 1)))
= 0

> (array-foldl + 0 (ArrayMap ArrayXor (ArrayOfInt32 4) (ArrayOfInt32 7)))
= 3

> (array-foldl + 0 (ArrayMap ArrayXor (ArrayOfInt32 4) (ArrayOfInt32 10)))
= 14


NAND
> (array-foldl + 0 (ArrayMap ArrayNand (ArrayOfInt32 3) (ArrayOfInt32 2)))
= -3

> (array-foldl + 0 (ArrayMap ArrayNand (ArrayOfInt32 4) (ArrayOfInt32 7)))
= -5


Compress the second array by taking the elements where the corresponding element in the first array is non-zero
> (array-foldl + 0 (ArrayCompress (ArrayGenerate (ArrayOfInt32 0) 1) (ArrayOfInt32 42)))
= 0

> (array-foldl + 0 (ArrayCompress (ArrayOfInt32 0) (ArrayOfInt32 42)))
= 0

> (array-foldl + 0 (ArrayShape (ArrayCompress (ArrayOfInt32 0) (ArrayOfInt32 42))))
= 0

> (array-foldl + 0 (ArrayCompress (ArrayOfInt32 1) (ArrayOfInt32 42)))
= 42

> (array-foldl + 0 (ArrayCompress (ArrayOfInt32 -1) (ArrayOfInt32 42)))
= 42

| (def a () (ArrayConcat (ArrayOfInt32 1) (ArrayOfInt32 0)))
| (def b () (ArrayConcat (ArrayOfInt32 3) (ArrayConcat (ArrayOfInt32 2) (ArrayOfInt32 1))))
> (array-foldl + 0 (ArrayCompress (a) (b)))
= 3

| (def a () (ArrayConcat (ArrayOfInt32 0) (ArrayConcat (ArrayOfInt32 1) (ArrayOfInt32 0))))
| (def b () (ArrayConcat (ArrayOfInt32 3) (ArrayConcat (ArrayOfInt32 2) (ArrayOfInt32 1))))
> (array-foldl + 0 (ArrayCompress (a) (b)))
= 2

| (def a () (ArrayConcat (ArrayOfInt32 0) (ArrayConcat (ArrayOfInt32 1) (ArrayOfInt32 0))))
| (def b () (ArrayConcat (ArrayOfInt32 3) (ArrayConcat (ArrayOfInt32 2) (ArrayOfInt32 1))))
> (array-foldl + 0 (ArrayShape (ArrayCompress (a) (b))))
= 1

| (def a () (ArrayConcat (ArrayOfInt32 0) (ArrayConcat (ArrayOfInt32 2) (ArrayOfInt32 0))))
| (def b () (ArrayConcat (ArrayOfInt32 3) (ArrayConcat (ArrayOfInt32 2) (ArrayOfInt32 1))))
> (array-foldl + 0 (ArrayShape (ArrayCompress (a) (b))))
= 1


Should perform a reduce operation over a 1-D array.
> (array-foldl * 1 (ArrayReduce ArrayAdd 99 (ArrayGenerate (ArrayOfInt32 0) 0)))
= 99

> (array-foldl * 1 (ArrayReduce ArrayAdd 1 (ArrayOfInt32 1)))
= 2

| (def array123 () (ArrayConcat (ArrayOfInt32 1) (ArrayConcat (ArrayOfInt32 2) (ArrayOfInt32 3))))
> (array-foldl * 1 (ArrayReduce ArrayAdd 0 (array123)))
= 6

| (def array123 () (ArrayConcat (ArrayOfInt32 1) (ArrayConcat (ArrayOfInt32 2) (ArrayOfInt32 3))))
> (array-foldl * 1 (ArrayReduce ArrayAdd 1 (array123)))
= 7

| (def array111 () (ArrayConcat (ArrayOfInt32 1) (ArrayConcat (ArrayOfInt32 1) (ArrayOfInt32 1))))
> (array-foldl * 1 (ArrayReduce ArrayXor 0 (array111)))
= 1

| (def array111 () (ArrayConcat (ArrayOfInt32 1) (ArrayConcat (ArrayOfInt32 1) (ArrayOfInt32 1))))
> (array-foldl * 1 (ArrayReduce ArrayXor 1 (array111)))
= 0
