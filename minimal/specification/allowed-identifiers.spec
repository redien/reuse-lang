
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
| (typ if MyEmpty)
| (typ (mytype if) (MyCons if))
| (def if () 1)
| (def if' (if) if)
> (if' 10)
= 10

| (typ then MyEmpty)
| (typ (mytype then) (MyCons then))
| (def then () 1)
| (def then' (then) then)
> (then' 10)
= 10

| (typ else MyEmpty)
| (typ (mytype else) (MyCons else))
| (def else () 1)
| (def else' (else) else)
> (else' 10)
= 10

| (typ end MyEmpty)
| (typ (mytype end) (MyCons end))
| (def end () 1)
| (def end' (end) end)
> (end' 10)
= 10

| (typ with MyEmpty)
| (typ (mytype with) (MyCons with))
| (def with () 1)
| (def with' (with) with)
> (with' 10)
= 10

| (typ in MyEmpty)
| (typ (mytype in) (MyCons in))
| (def in () 1)
| (def in' (in) in)
> (in' 10)
= 10

| (typ of MyEmpty)
| (typ (mytype of) (MyCons of))
| (def of () 1)
| (def of' (of) of)
> (of' 10)
= 10

| (typ type MyEmpty)
| (typ (mytype type) (MyCons type))
| (def type () 1)
| (def type' (type) type)
> (type' 10)
= 10

| (typ data MyEmpty)
| (typ (mytype data) (MyCons data))
| (def data () 1)
| (def data' (data) data)
> (data' 10)
= 10

| (typ lambda MyEmpty)
| (typ (mytype lambda) (MyCons lambda))
| (def lambda () 1)
| (def lambda' (lambda) lambda)
> (lambda' 10)
= 10

| (typ fun MyEmpty)
| (typ (mytype fun) (MyCons fun))
| (def fun () 1)
| (def fun' (fun) fun)
> (fun' 10)
= 10

| (typ let MyEmpty)
| (typ (mytype let) (MyCons let))
| (def let () 1)
| (def let' (let) let)
> (let' 10)
= 10

| (typ var MyEmpty)
| (typ (mytype var) (MyCons var))
| (def var () 1)
| (def var' (var) var)
> (var' 10)
= 10

| (typ class MyEmpty)
| (typ (mytype class) (MyCons class))
| (def class () 1)
| (def class' (class) class)
> (class' 10)
= 10

| (typ and MyEmpty)
| (typ (mytype and) (MyCons and))
| (def and () 1)
| (def and' (and) and)
> (and' 10)
= 10

| (typ or MyEmpty)
| (typ (mytype or) (MyCons or))
| (def or () 1)
| (def or' (or) or)
> (or' 10)
= 10

| (typ not MyEmpty)
| (typ (mytype not) (MyCons not))
| (def not () 1)
| (def not' (not) not)
> (not' 10)
= 10

| (typ constructor MyEmpty)
| (typ (mytype constructor) (MyCons constructor))
| (def constructor () 1)
| (def constructor' (constructor) constructor)
> (constructor' 10)
= 10

| (typ open MyEmpty)
| (typ (mytype open) (MyCons open))
| (def open () 1)
| (def open' (open) open)
> (open' 10)
= 10

| (typ close MyEmpty)
| (typ (mytype close) (MyCons close))
| (def close () 1)
| (def close' (close) close)
> (close' 10)
= 10

| (typ as MyEmpty)
| (typ (mytype as) (MyCons as))
| (def as () 1)
| (def as' (as) as)
> (as' 10)
= 10

| (typ assert MyEmpty)
| (typ (mytype assert) (MyCons assert))
| (def assert () 1)
| (def assert' (assert) assert)
> (assert' 10)
= 10

| (typ asr MyEmpty)
| (typ (mytype asr) (MyCons asr))
| (def asr () 1)
| (def asr' (asr) asr)
> (asr' 10)
= 10

| (typ begin MyEmpty)
| (typ (mytype begin) (MyCons begin))
| (def begin () 1)
| (def begin' (begin) begin)
> (begin' 10)
= 10

| (typ constraint MyEmpty)
| (typ (mytype constraint) (MyCons constraint))
| (def constraint () 1)
| (def constraint' (constraint) constraint)
> (constraint' 10)
= 10

| (typ do MyEmpty)
| (typ (mytype do) (MyCons do))
| (def do () 1)
| (def do' (do) do)
> (do' 10)
= 10

| (typ done MyEmpty)
| (typ (mytype done) (MyCons done))
| (def done () 1)
| (def done' (done) done)
> (done' 10)
= 10

| (typ downto MyEmpty)
| (typ (mytype downto) (MyCons downto))
| (def downto () 1)
| (def downto' (downto) downto)
> (downto' 10)
= 10

| (typ exception MyEmpty)
| (typ (mytype exception) (MyCons exception))
| (def exception () 1)
| (def exception' (exception) exception)
> (exception' 10)
= 10

| (typ external MyEmpty)
| (typ (mytype external) (MyCons external))
| (def external () 1)
| (def external' (external) external)
> (external' 10)
= 10

| (typ false MyEmpty)
| (typ (mytype false) (MyCons false))
| (def false () 1)
| (def false' (false) false)
> (false' 10)
= 10

| (typ true MyEmpty)
| (typ (mytype true) (MyCons true))
| (def true () 1)
| (def true' (true) true)
> (true' 10)
= 10

| (typ for MyEmpty)
| (typ (mytype for) (MyCons for))
| (def for () 1)
| (def for' (for) for)
> (for' 10)
= 10

| (typ function MyEmpty)
| (typ (mytype function) (MyCons function))
| (def function () 1)
| (def function' (function) function)
> (function' 10)
= 10

| (typ functor MyEmpty)
| (typ (mytype functor) (MyCons functor))
| (def functor () 1)
| (def functor' (functor) functor)
> (functor' 10)
= 10

| (typ if MyEmpty)
| (typ (mytype if) (MyCons if))
| (def if () 1)
| (def if' (if) if)
> (if' 10)
= 10

| (typ include MyEmpty)
| (typ (mytype include) (MyCons include))
| (def include () 1)
| (def include' (include) include)
> (include' 10)
= 10

| (typ inherit MyEmpty)
| (typ (mytype inherit) (MyCons inherit))
| (def inherit () 1)
| (def inherit' (inherit) inherit)
> (inherit' 10)
= 10

| (typ initializer MyEmpty)
| (typ (mytype initializer) (MyCons initializer))
| (def initializer () 1)
| (def initializer' (initializer) initializer)
> (initializer' 10)
= 10

| (typ land MyEmpty)
| (typ (mytype land) (MyCons land))
| (def land () 1)
| (def land' (land) land)
> (land' 10)
= 10

| (typ lazy MyEmpty)
| (typ (mytype lazy) (MyCons lazy))
| (def lazy () 1)
| (def lazy' (lazy) lazy)
> (lazy' 10)
= 10

| (typ lor MyEmpty)
| (typ (mytype lor) (MyCons lor))
| (def lor () 1)
| (def lor' (lor) lor)
> (lor' 10)
= 10

| (typ lsl MyEmpty)
| (typ (mytype lsl) (MyCons lsl))
| (def lsl () 1)
| (def lsl' (lsl) lsl)
> (lsl' 10)
= 10

| (typ lsr MyEmpty)
| (typ (mytype lsr) (MyCons lsr))
| (def lsr () 1)
| (def lsr' (lsr) lsr)
> (lsr' 10)
= 10

| (typ lxor MyEmpty)
| (typ (mytype lxor) (MyCons lxor))
| (def lxor () 1)
| (def lxor' (lxor) lxor)
> (lxor' 10)
= 10

| (typ method MyEmpty)
| (typ (mytype method) (MyCons method))
| (def method () 1)
| (def method' (method) method)
> (method' 10)
= 10

| (typ mod MyEmpty)
| (typ (mytype mod) (MyCons mod))
| (def mod () 1)
| (def mod' (mod) mod)
> (mod' 10)
= 10

| (typ module MyEmpty)
| (typ (mytype module) (MyCons module))
| (def module () 1)
| (def module' (module) module)
> (module' 10)
= 10

| (typ mutable MyEmpty)
| (typ (mytype mutable) (MyCons mutable))
| (def mutable () 1)
| (def mutable' (mutable) mutable)
> (mutable' 10)
= 10

| (typ new MyEmpty)
| (typ (mytype new) (MyCons new))
| (def new () 1)
| (def new' (new) new)
> (new' 10)
= 10

| (typ nonrec MyEmpty)
| (typ (mytype nonrec) (MyCons nonrec))
| (def nonrec () 1)
| (def nonrec' (nonrec) nonrec)
> (nonrec' 10)
= 10

| (typ object MyEmpty)
| (typ (mytype object) (MyCons object))
| (def object () 1)
| (def object' (object) object)
> (object' 10)
= 10

| (typ private MyEmpty)
| (typ (mytype private) (MyCons private))
| (def private () 1)
| (def private' (private) private)
> (private' 10)
= 10

| (typ rec MyEmpty)
| (typ (mytype rec) (MyCons rec))
| (def rec () 1)
| (def rec' (rec) rec)
> (rec' 10)
= 10

| (typ sig MyEmpty)
| (typ (mytype sig) (MyCons sig))
| (def sig () 1)
| (def sig' (sig) sig)
> (sig' 10)
= 10

| (typ struct MyEmpty)
| (typ (mytype struct) (MyCons struct))
| (def struct () 1)
| (def struct' (struct) struct)
> (struct' 10)
= 10

| (typ try MyEmpty)
| (typ (mytype try) (MyCons try))
| (def try () 1)
| (def try' (try) try)
> (try' 10)
= 10

| (typ val MyEmpty)
| (typ (mytype val) (MyCons val))
| (def val () 1)
| (def val' (val) val)
> (val' 10)
= 10

| (typ virtual MyEmpty)
| (typ (mytype virtual) (MyCons virtual))
| (def virtual () 1)
| (def virtual' (virtual) virtual)
> (virtual' 10)
= 10

| (typ when MyEmpty)
| (typ (mytype when) (MyCons when))
| (def when () 1)
| (def when' (when) when)
> (when' 10)
= 10

| (typ while MyEmpty)
| (typ (mytype while) (MyCons while))
| (def while () 1)
| (def while' (while) while)
> (while' 10)
= 10

| (typ parser MyEmpty)
| (typ (mytype parser) (MyCons parser))
| (def parser () 1)
| (def parser' (parser) parser)
> (parser' 10)
= 10

| (typ value MyEmpty)
| (typ (mytype value) (MyCons value))
| (def value () 1)
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
