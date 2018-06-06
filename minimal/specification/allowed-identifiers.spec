
Should allow defining boolean type
| (typ boolean True False)
> (match True True 1 False 2)
= 1

| (typ bool True False)
> (match False True 1 False 2)
= 2

Should allow defining types with name type
| (typ type A)
> (match A A 3)
= 3

Should allow defining maybe type
| (typ (maybe a) None (Some a))
> (match (Some 4) (Some x) x None 0)
= 4

Should allow defining functions with non-latin characters
| (def < (a b) a)
> (< 5 2)
= 5

| (def 日本語 (a) a)
> (日本語 6)
= 6

Should allow defining pattern captures with non-latin characters
| (typ (myType a) (MyPair a))
> (match (MyPair 7) (MyPair 日本語) 日本語)
= 7

Should allow defining constructors with non-latin characters
| (typ (myType a) (A日本語 a))
> (match (A日本語 8) (A日本語 x) x)
= 8

Should allow defining function arguments with non-latin characters
| (def a (日本語) 日本語)
> (a 9)
= 9

Should allow commonly reserved words as variable names
| (def if' (if) if)
> (if' 10)
= 10

| (def then' (then) then)
> (then' 10)
= 10

| (def else' (else) else)
> (else' 10)
= 10

| (def end' (end) end)
> (end' 10)
= 10

| (def with' (with) with)
> (with' 10)
= 10

| (def in' (in) in)
> (in' 10)
= 10

| (def of' (of) of)
> (of' 10)
= 10

| (def type' (type) type)
> (type' 10)
= 10

| (def data' (data) data)
> (data' 10)
= 10

| (def lambda' (lambda) lambda)
> (lambda' 10)
= 10

| (def fun' (fun) fun)
> (fun' 10)
= 10

| (def let' (let) let)
> (let' 10)
= 10

| (def var' (var) var)
> (var' 10)
= 10

| (def class' (class) class)
> (class' 10)
= 10

Type names should be allowed as capture variables
| (typ a (B int32))
> (match (B 11) (B a) a)
= 11

Type names should be allowed as function arguments
| (typ a (B int32))
| (def f (a) a)
> (match (B 12) (B x) (f x))
= 12
