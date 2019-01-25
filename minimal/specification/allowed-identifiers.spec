
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

| (def and' (and) and)
> (and' 10)
= 10

| (def or' (or) or)
> (or' 10)
= 10

| (def not' (not) not)
> (not' 10)
= 10

| (def constructor' (constructor) constructor)
> (constructor' 10)
= 10

| (def open' (open) open)
> (open' 10)
= 10

| (def close' (close) close)
> (close' 10)
= 10

| (def as' (as) as)
> (as' 10)
= 10

| (def assert' (assert) assert)
> (assert' 10)
= 10

| (def asr' (asr) asr)
> (asr' 10)
= 10

| (def begin' (begin) begin)
> (begin' 10)
= 10

| (def constraint' (constraint) constraint)
> (constraint' 10)
= 10

| (def do' (do) do)
> (do' 10)
= 10

| (def done' (done) done)
> (done' 10)
= 10

| (def downto' (downto) downto)
> (downto' 10)
= 10

| (def exception' (exception) exception)
> (exception' 10)
= 10

| (def external' (external) external)
> (external' 10)
= 10

| (def false' (false) false)
> (false' 10)
= 10

| (def true' (true) true)
> (true' 10)
= 10

| (def for' (for) for)
> (for' 10)
= 10

| (def function' (function) function)
> (function' 10)
= 10

| (def functor' (functor) functor)
> (functor' 10)
= 10

| (def if' (if) if)
> (if' 10)
= 10

| (def include' (include) include)
> (include' 10)
= 10

| (def inherit' (inherit) inherit)
> (inherit' 10)
= 10

| (def initializer' (initializer) initializer)
> (initializer' 10)
= 10

| (def land' (land) land)
> (land' 10)
= 10

| (def lazy' (lazy) lazy)
> (lazy' 10)
= 10

| (def lor' (lor) lor)
> (lor' 10)
= 10

| (def lsl' (lsl) lsl)
> (lsl' 10)
= 10

| (def lsr' (lsr) lsr)
> (lsr' 10)
= 10

| (def lxor' (lxor) lxor)
> (lxor' 10)
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
