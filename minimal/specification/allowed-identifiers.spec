
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
| (typ (mytype if) (MyCons if))
| (def if' (if) if)
> (if' 10)
= 10

| (typ (mytype then) (MyCons then))
| (def then' (then) then)
> (then' 10)
= 10

| (typ (mytype else) (MyCons else))
| (def else' (else) else)
> (else' 10)
= 10

| (typ (mytype end) (MyCons end))
| (def end' (end) end)
> (end' 10)
= 10

| (typ (mytype with) (MyCons with))
| (def with' (with) with)
> (with' 10)
= 10

| (typ (mytype in) (MyCons in))
| (def in' (in) in)
> (in' 10)
= 10

| (typ (mytype of) (MyCons of))
| (def of' (of) of)
> (of' 10)
= 10

| (typ (mytype type) (MyCons type))
| (def type' (type) type)
> (type' 10)
= 10

| (typ (mytype data) (MyCons data))
| (def data' (data) data)
> (data' 10)
= 10

| (typ (mytype lambda) (MyCons lambda))
| (def lambda' (lambda) lambda)
> (lambda' 10)
= 10

| (typ (mytype fun) (MyCons fun))
| (def fun' (fun) fun)
> (fun' 10)
= 10

| (typ (mytype let) (MyCons let))
| (def let' (let) let)
> (let' 10)
= 10

| (typ (mytype var) (MyCons var))
| (def var' (var) var)
> (var' 10)
= 10

| (typ (mytype class) (MyCons class))
| (def class' (class) class)
> (class' 10)
= 10

| (typ (mytype and) (MyCons and))
| (def and' (and) and)
> (and' 10)
= 10

| (typ (mytype or) (MyCons or))
| (def or' (or) or)
> (or' 10)
= 10

| (typ (mytype not) (MyCons not))
| (def not' (not) not)
> (not' 10)
= 10

| (typ (mytype constructor) (MyCons constructor))
| (def constructor' (constructor) constructor)
> (constructor' 10)
= 10

| (typ (mytype open) (MyCons open))
| (def open' (open) open)
> (open' 10)
= 10

| (typ (mytype close) (MyCons close))
| (def close' (close) close)
> (close' 10)
= 10

| (typ (mytype as) (MyCons as))
| (def as' (as) as)
> (as' 10)
= 10

| (typ (mytype assert) (MyCons assert))
| (def assert' (assert) assert)
> (assert' 10)
= 10

| (typ (mytype asr) (MyCons asr))
| (def asr' (asr) asr)
> (asr' 10)
= 10

| (typ (mytype begin) (MyCons begin))
| (def begin' (begin) begin)
> (begin' 10)
= 10

| (typ (mytype constraint) (MyCons constraint))
| (def constraint' (constraint) constraint)
> (constraint' 10)
= 10

| (typ (mytype do) (MyCons do))
| (def do' (do) do)
> (do' 10)
= 10

| (typ (mytype done) (MyCons done))
| (def done' (done) done)
> (done' 10)
= 10

| (typ (mytype downto) (MyCons downto))
| (def downto' (downto) downto)
> (downto' 10)
= 10

| (typ (mytype exception) (MyCons exception))
| (def exception' (exception) exception)
> (exception' 10)
= 10

| (typ (mytype external) (MyCons external))
| (def external' (external) external)
> (external' 10)
= 10

| (typ (mytype false) (MyCons false))
| (def false' (false) false)
> (false' 10)
= 10

| (typ (mytype true) (MyCons true))
| (def true' (true) true)
> (true' 10)
= 10

| (typ (mytype for) (MyCons for))
| (def for' (for) for)
> (for' 10)
= 10

| (typ (mytype function) (MyCons function))
| (def function' (function) function)
> (function' 10)
= 10

| (typ (mytype functor) (MyCons functor))
| (def functor' (functor) functor)
> (functor' 10)
= 10

| (typ (mytype if) (MyCons if))
| (def if' (if) if)
> (if' 10)
= 10

| (typ (mytype include) (MyCons include))
| (def include' (include) include)
> (include' 10)
= 10

| (typ (mytype inherit) (MyCons inherit))
| (def inherit' (inherit) inherit)
> (inherit' 10)
= 10

| (typ (mytype initializer) (MyCons initializer))
| (def initializer' (initializer) initializer)
> (initializer' 10)
= 10

| (typ (mytype land) (MyCons land))
| (def land' (land) land)
> (land' 10)
= 10

| (typ (mytype lazy) (MyCons lazy))
| (def lazy' (lazy) lazy)
> (lazy' 10)
= 10

| (typ (mytype lor) (MyCons lor))
| (def lor' (lor) lor)
> (lor' 10)
= 10

| (typ (mytype lsl) (MyCons lsl))
| (def lsl' (lsl) lsl)
> (lsl' 10)
= 10

| (typ (mytype lsr) (MyCons lsr))
| (def lsr' (lsr) lsr)
> (lsr' 10)
= 10

| (typ (mytype lxor) (MyCons lxor))
| (def lxor' (lxor) lxor)
> (lxor' 10)
= 10

| (typ (mytype method) (MyCons method))
| (def method' (method) method)
> (method' 10)
= 10

| (typ (mytype mod) (MyCons mod))
| (def mod' (mod) mod)
> (mod' 10)
= 10

| (typ (mytype module) (MyCons module))
| (def module' (module) module)
> (module' 10)
= 10

| (typ (mytype mutable) (MyCons mutable))
| (def mutable' (mutable) mutable)
> (mutable' 10)
= 10

| (typ (mytype new) (MyCons new))
| (def new' (new) new)
> (new' 10)
= 10

| (typ (mytype nonrec) (MyCons nonrec))
| (def nonrec' (nonrec) nonrec)
> (nonrec' 10)
= 10

| (typ (mytype object) (MyCons object))
| (def object' (object) object)
> (object' 10)
= 10

| (typ (mytype private) (MyCons private))
| (def private' (private) private)
> (private' 10)
= 10

| (typ (mytype rec) (MyCons rec))
| (def rec' (rec) rec)
> (rec' 10)
= 10

| (typ (mytype sig) (MyCons sig))
| (def sig' (sig) sig)
> (sig' 10)
= 10

| (typ (mytype struct) (MyCons struct))
| (def struct' (struct) struct)
> (struct' 10)
= 10

| (typ (mytype try) (MyCons try))
| (def try' (try) try)
> (try' 10)
= 10

| (typ (mytype val) (MyCons val))
| (def val' (val) val)
> (val' 10)
= 10

| (typ (mytype virtual) (MyCons virtual))
| (def virtual' (virtual) virtual)
> (virtual' 10)
= 10

| (typ (mytype when) (MyCons when))
| (def when' (when) when)
> (when' 10)
= 10

| (typ (mytype while) (MyCons while))
| (def while' (while) while)
> (while' 10)
= 10

| (typ (mytype parser) (MyCons parser))
| (def parser' (parser) parser)
> (parser' 10)
= 10

| (typ (mytype value) (MyCons value))
| (def value' (value) value)
> (value' 10)
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
