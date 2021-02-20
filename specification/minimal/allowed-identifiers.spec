
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

| (typ and MyEmpty)
| (typ (mytype and) (MyCons and))
| (def and () 1)
| (def and' (and _) and)
> (and' 10 and)
= 10

| (typ as MyEmpty)
| (typ (mytype as) (MyCons as))
| (def as () 1)
| (def as' (as _) as)
> (as' 10 as)
= 10

| (typ assert MyEmpty)
| (typ (mytype assert) (MyCons assert))
| (def assert () 1)
| (def assert' (assert _) assert)
> (assert' 10 assert)
= 10

| (typ asr MyEmpty)
| (typ (mytype asr) (MyCons asr))
| (def asr () 1)
| (def asr' (asr _) asr)
> (asr' 10 asr)
= 10

| (typ arguments MyEmpty)
| (typ (mytype arguments) (MyCons arguments))
| (def arguments () 1)
| (def arguments' (arguments _) arguments)
> (arguments' 10 arguments)
= 10

| (typ await MyEmpty)
| (typ (mytype await) (MyCons await))
| (def await () 1)
| (def await' (await _) await)
> (await' 10 await)
= 10

| (typ begin MyEmpty)
| (typ (mytype begin) (MyCons begin))
| (def begin () 1)
| (def begin' (begin _) begin)
> (begin' 10 begin)
= 10

| (typ break MyEmpty)
| (typ (mytype break) (MyCons break))
| (def break () 1)
| (def break' (break _) break)
> (break' 10 break)
= 10

| (typ class MyEmpty)
| (typ (mytype class) (MyCons class))
| (def class () 1)
| (def class' (class _) class)
> (class' 10 class)
= 10

| (typ const MyEmpty)
| (typ (mytype const) (MyCons const))
| (def const () 1)
| (def const' (const _) const)
> (const' 10 const)
= 10

| (typ constructor MyEmpty)
| (typ (mytype constructor) (MyCons constructor))
| (def constructor () 1)
| (def constructor' (constructor _) constructor)
> (constructor' 10 constructor)
= 10

| (typ close MyEmpty)
| (typ (mytype close) (MyCons close))
| (def close () 1)
| (def close' (close _) close)
> (close' 10 close)
= 10

| (typ constraint MyEmpty)
| (typ (mytype constraint) (MyCons constraint))
| (def constraint () 1)
| (def constraint' (constraint _) constraint)
> (constraint' 10 constraint)
= 10

| (typ continue MyEmpty)
| (typ (mytype continue) (MyCons continue))
| (def continue () 1)
| (def continue' (continue _) continue)
> (continue' 10 continue)
= 10

| (typ case MyEmpty)
| (typ (mytype case) (MyCons case))
| (def case () 1)
| (def case' (case _) case)
> (case' 10 case)
= 10

| (typ catch MyEmpty)
| (typ (mytype catch) (MyCons catch))
| (def catch () 1)
| (def catch' (catch _) catch)
> (catch' 10 catch)
= 10

| (typ data MyEmpty)
| (typ (mytype data) (MyCons data))
| (def data () 1)
| (def data' (data _) data)
> (data' 10 data)
= 10

| (typ debugger MyEmpty)
| (typ (mytype debugger) (MyCons debugger))
| (def debugger () 1)
| (def debugger' (debugger _) debugger)
> (debugger' 10 debugger)
= 10

| (typ delete MyEmpty)
| (typ (mytype delete) (MyCons delete))
| (def delete () 1)
| (def delete' (delete _) delete)
> (delete' 10 delete)
= 10

| (typ deriving MyEmpty)
| (typ (mytype deriving) (MyCons deriving))
| (def deriving () 1)
| (def deriving' (deriving _) deriving)
> (deriving' 10 deriving)
= 10

| (typ do MyEmpty)
| (typ (mytype do) (MyCons do))
| (def do () 1)
| (def do' (do _) do)
> (do' 10 do)
= 10

| (typ done MyEmpty)
| (typ (mytype done) (MyCons done))
| (def done () 1)
| (def done' (done _) done)
> (done' 10 done)
= 10

| (typ downto MyEmpty)
| (typ (mytype downto) (MyCons downto))
| (def downto () 1)
| (def downto' (downto _) downto)
> (downto' 10 downto)
= 10

| (typ default MyEmpty)
| (typ (mytype default) (MyCons default))
| (def default () 1)
| (def default' (default _) default)
> (default' 10 default)
= 10

| (typ exception MyEmpty)
| (typ (mytype exception) (MyCons exception))
| (def exception () 1)
| (def exception' (exception _) exception)
> (exception' 10 exception)
= 10

| (typ external MyEmpty)
| (typ (mytype external) (MyCons external))
| (def external () 1)
| (def external' (external _) external)
> (external' 10 external)
= 10

| (typ export MyEmpty)
| (typ (mytype export) (MyCons export))
| (def export () 1)
| (def export' (export _) export)
> (export' 10 export)
= 10

| (typ extends MyEmpty)
| (typ (mytype extends) (MyCons extends))
| (def extends () 1)
| (def extends' (extends _) extends)
> (extends' 10 extends)
= 10

| (typ else MyEmpty)
| (typ (mytype else) (MyCons else))
| (def else () 1)
| (def else' (else _) else)
> (else' 10 else)
= 10

| (typ end MyEmpty)
| (typ (mytype end) (MyCons end))
| (def end () 1)
| (def end' (end _) end)
> (end' 10 end)
= 10

| (typ enum MyEmpty)
| (typ (mytype enum) (MyCons enum))
| (def enum () 1)
| (def enum' (enum _) enum)
> (enum' 10 enum)
= 10

| (typ eval MyEmpty)
| (typ (mytype eval) (MyCons eval))
| (def eval () 1)
| (def eval' (eval _) eval)
> (eval' 10 eval)
= 10

| (typ fun MyEmpty)
| (typ (mytype fun) (MyCons fun))
| (def fun () 1)
| (def fun' (fun _) fun)
> (fun' 10 fun)
= 10

| (typ family MyEmpty)
| (typ (mytype family) (MyCons family))
| (def family () 1)
| (def family' (family _) family)
> (family' 10 family)
= 10

| (typ false MyEmpty)
| (typ (mytype false) (MyCons false))
| (def false () 1)
| (def false' (false _) false)
> (false' 10 false)
= 10

| (typ finally MyEmpty)
| (typ (mytype finally) (MyCons finally))
| (def finally () 1)
| (def finally' (finally _) finally)
> (finally' 10 finally)
= 10

| (typ for MyEmpty)
| (typ (mytype for) (MyCons for))
| (def for () 1)
| (def for' (for _) for)
> (for' 10 for)
= 10

| (typ forall MyEmpty)
| (typ (mytype forall) (MyCons forall))
| (def forall () 1)
| (def forall' (forall _) forall)
> (forall' 10 forall)
= 10

| (typ function MyEmpty)
| (typ (mytype function) (MyCons function))
| (def function () 1)
| (def function' (function _) function)
> (function' 10 function)
= 10

| (typ functor MyEmpty)
| (typ (mytype functor) (MyCons functor))
| (def functor () 1)
| (def functor' (functor _) functor)
> (functor' 10 functor)
= 10

| (typ foreign MyEmpty)
| (typ (mytype foreign) (MyCons foreign))
| (def foreign () 1)
| (def foreign' (foreign _) foreign)
> (foreign' 10 foreign)
= 10

| (typ hiding MyEmpty)
| (typ (mytype hiding) (MyCons hiding))
| (def hiding () 1)
| (def hiding' (hiding _) hiding)
> (hiding' 10 hiding)
= 10

| (typ id MyEmpty)
| (typ (mytype id) (MyCons id))
| (def id () 1)
| (def id' (id _) id)
> (id' 10 id)
= 10

| (typ if MyEmpty)
| (typ (mytype if) (MyCons if))
| (def if () 1)
| (def if' (if _) if)
> (if' 10 if)
= 10

| (typ include MyEmpty)
| (typ (mytype include) (MyCons include))
| (def include () 1)
| (def include' (include _) include)
> (include' 10 include)
= 10

| (typ import MyEmpty)
| (typ (mytype import) (MyCons import))
| (def import () 1)
| (def import' (import _) import)
> (import' 10 import)
= 10

| (typ implements MyEmpty)
| (typ (mytype implements) (MyCons implements))
| (def implements () 1)
| (def implements' (implements _) implements)
> (implements' 10 implements)
= 10

| (typ inherit MyEmpty)
| (typ (mytype inherit) (MyCons inherit))
| (def inherit () 1)
| (def inherit' (inherit _) inherit)
> (inherit' 10 inherit)
= 10

| (typ initializer MyEmpty)
| (typ (mytype initializer) (MyCons initializer))
| (def initializer () 1)
| (def initializer' (initializer _) initializer)
> (initializer' 10 initializer)
= 10

| (typ instance MyEmpty)
| (typ (mytype instance) (MyCons instance))
| (def instance () 1)
| (def instance' (instance _) instance)
> (instance' 10 instance)
= 10

| (typ instanceof MyEmpty)
| (typ (mytype instanceof) (MyCons instanceof))
| (def instanceof () 1)
| (def instanceof' (instanceof _) instanceof)
> (instanceof' 10 instanceof)
= 10

| (typ infinity MyEmpty)
| (typ (mytype infinity) (MyCons infinity))
| (def infinity () 1)
| (def infinity' (infinity _) infinity)
> (infinity' 10 infinity)
= 10

| (typ infix MyEmpty)
| (typ (mytype infix) (MyCons infix))
| (def infix () 1)
| (def infix' (infix _) infix)
> (infix' 10 infix)
= 10

| (typ infixl MyEmpty)
| (typ (mytype infixl) (MyCons infixl))
| (def infixl () 1)
| (def infixl' (infixl _) infixl)
> (infixl' 10 infixl)
= 10

| (typ infixr MyEmpty)
| (typ (mytype infixr) (MyCons infixr))
| (def infixr () 1)
| (def infixr' (infixr _) infixr)
> (infixr' 10 infixr)
= 10

| (typ in MyEmpty)
| (typ (mytype in) (MyCons in))
| (def in () 1)
| (def in' (in _) in)
> (in' 10 in)
= 10

| (typ interface MyEmpty)
| (typ (mytype interface) (MyCons interface))
| (def interface () 1)
| (def interface' (interface _) interface)
> (interface' 10 interface)
= 10

| (typ land MyEmpty)
| (typ (mytype land) (MyCons land))
| (def land () 1)
| (def land' (land _) land)
> (land' 10 land)
= 10

| (typ lazy MyEmpty)
| (typ (mytype lazy) (MyCons lazy))
| (def lazy () 1)
| (def lazy' (lazy _) lazy)
> (lazy' 10 lazy)
= 10

| (typ lor MyEmpty)
| (typ (mytype lor) (MyCons lor))
| (def lor () 1)
| (def lor' (lor _) lor)
> (lor' 10 lor)
= 10

| (typ lsl MyEmpty)
| (typ (mytype lsl) (MyCons lsl))
| (def lsl () 1)
| (def lsl' (lsl _) lsl)
> (lsl' 10 lsl)
= 10

| (typ lsr MyEmpty)
| (typ (mytype lsr) (MyCons lsr))
| (def lsr () 1)
| (def lsr' (lsr _) lsr)
> (lsr' 10 lsr)
= 10

| (typ lxor MyEmpty)
| (typ (mytype lxor) (MyCons lxor))
| (def lxor () 1)
| (def lxor' (lxor _) lxor)
> (lxor' 10 lxor)
= 10

| (typ lambda MyEmpty)
| (typ (mytype lambda) (MyCons lambda))
| (def lambda () 1)
| (def lambda' (lambda _) lambda)
> (lambda' 10 lambda)
= 10

| (typ let MyEmpty)
| (typ (mytype let) (MyCons let))
| (def let () 1)
| (def let' (let _) let)
> (let' 10 let)
= 10

| (typ method MyEmpty)
| (typ (mytype method) (MyCons method))
| (def method () 1)
| (def method' (method _) method)
> (method' 10 method)
= 10

| (typ mod MyEmpty)
| (typ (mytype mod) (MyCons mod))
| (def mod () 1)
| (def mod' (mod _) mod)
> (mod' 10 mod)
= 10

| (typ module MyEmpty)
| (typ (mytype module) (MyCons module))
| (def module () 1)
| (def module' (module _) module)
> (module' 10 module)
= 10

| (typ mutable MyEmpty)
| (typ (mytype mutable) (MyCons mutable))
| (def mutable () 1)
| (def mutable' (mutable _) mutable)
> (mutable' 10 mutable)
= 10

| (typ NaN MyEmpty)
| (typ (mytype NaN) (MyCons NaN))
| (def NaN () 1)
| (def NaN' (NaN _) NaN)
> (NaN' 10 NaN)
= 10

| (typ new MyEmpty)
| (typ (mytype new) (MyCons new))
| (def new () 1)
| (def new' (new _) new)
> (new' 10 new)
= 10

| (typ newtype MyEmpty)
| (typ (mytype newtype) (MyCons newtype))
| (def newtype () 1)
| (def newtype' (newtype _) newtype)
> (newtype' 10 newtype)
= 10

| (typ nonrec MyEmpty)
| (typ (mytype nonrec) (MyCons nonrec))
| (def nonrec () 1)
| (def nonrec' (nonrec _) nonrec)
> (nonrec' 10 nonrec)
= 10

| (typ not MyEmpty)
| (typ (mytype not) (MyCons not))
| (def not () 1)
| (def not' (not _) not)
> (not' 10 not)
= 10

| (typ null MyEmpty)
| (typ (mytype null) (MyCons null))
| (def null () 1)
| (def null' (null _) null)
> (null' 10 null)
= 10

| (typ object MyEmpty)
| (typ (mytype object) (MyCons object))
| (def object () 1)
| (def object' (object _) object)
> (object' 10 object)
= 10

| (typ or MyEmpty)
| (typ (mytype or) (MyCons or))
| (def or () 1)
| (def or' (or _) or)
> (or' 10 or)
= 10

| (typ open MyEmpty)
| (typ (mytype open) (MyCons open))
| (def open () 1)
| (def open' (open _) open)
> (open' 10 open)
= 10

| (typ of MyEmpty)
| (typ (mytype of) (MyCons of))
| (def of () 1)
| (def of' (of _) of)
> (of' 10 of)
= 10

| (typ private MyEmpty)
| (typ (mytype private) (MyCons private))
| (def private () 1)
| (def private' (private _) private)
> (private' 10 private)
= 10

| (typ parser MyEmpty)
| (typ (mytype parser) (MyCons parser))
| (def parser () 1)
| (def parser' (parser _) parser)
> (parser' 10 parser)
= 10

| (typ package MyEmpty)
| (typ (mytype package) (MyCons package))
| (def package () 1)
| (def package' (package _) package)
> (package' 10 package)
= 10

| (typ proc MyEmpty)
| (typ (mytype proc) (MyCons proc))
| (def proc () 1)
| (def proc' (proc _) proc)
> (proc' 10 proc)
= 10

| (typ protected MyEmpty)
| (typ (mytype protected) (MyCons protected))
| (def protected () 1)
| (def protected' (protected _) protected)
> (protected' 10 protected)
= 10

| (typ public MyEmpty)
| (typ (mytype public) (MyCons public))
| (def public () 1)
| (def public' (public _) public)
> (public' 10 public)
= 10

| (typ qualified MyEmpty)
| (typ (mytype qualified) (MyCons qualified))
| (def qualified () 1)
| (def qualified' (qualified _) qualified)
> (qualified' 10 qualified)
= 10

| (typ rec MyEmpty)
| (typ (mytype rec) (MyCons rec))
| (def rec () 1)
| (def rec' (rec _) rec)
> (rec' 10 rec)
= 10

| (typ rem MyEmpty)
| (typ (mytype rem) (MyCons rem))
| (def rem () 1)
| (def rem' (rem _) rem)
> (rem' 10 rem)
= 10

| (typ return MyEmpty)
| (typ (mytype return) (MyCons return))
| (def return () 1)
| (def return' (return _) return)
> (return' 10 return)
= 10

| (typ sig MyEmpty)
| (typ (mytype sig) (MyCons sig))
| (def sig () 1)
| (def sig' (sig _) sig)
> (sig' 10 sig)
= 10

| (typ static MyEmpty)
| (typ (mytype static) (MyCons static))
| (def static () 1)
| (def static' (static _) static)
> (static' 10 static)
= 10

| (typ struct MyEmpty)
| (typ (mytype struct) (MyCons struct))
| (def struct () 1)
| (def struct' (struct _) struct)
> (struct' 10 struct)
= 10

| (typ super MyEmpty)
| (typ (mytype super) (MyCons super))
| (def super () 1)
| (def super' (super _) super)
> (super' 10 super)
= 10

| (typ switch MyEmpty)
| (typ (mytype switch) (MyCons switch))
| (def switch () 1)
| (def switch' (switch _) switch)
> (switch' 10 switch)
= 10

| (typ true MyEmpty)
| (typ (mytype true) (MyCons true))
| (def true () 1)
| (def true' (true _) true)
> (true' 10 true)
= 10

| (typ then MyEmpty)
| (typ (mytype then) (MyCons then))
| (def then () 1)
| (def then' (then _) then)
> (then' 10 then)
= 10

| (typ this MyEmpty)
| (typ (mytype this) (MyCons this))
| (def this () 1)
| (def this' (this _) this)
> (this' 10 this)
= 10

| (typ throw MyEmpty)
| (typ (mytype throw) (MyCons throw))
| (def throw () 1)
| (def throw' (throw _) throw)
> (throw' 10 throw)
= 10

| (typ type MyEmpty)
| (typ (mytype type) (MyCons type))
| (def type () 1)
| (def type' (type _) type)
> (type' 10 type)
= 10

| (typ typeof MyEmpty)
| (typ (mytype typeof) (MyCons typeof))
| (def typeof () 1)
| (def typeof' (typeof _) typeof)
> (typeof' 10 typeof)
= 10

| (typ to MyEmpty)
| (typ (mytype to) (MyCons to))
| (def to () 1)
| (def to' (to _) to)
> (to' 10 to)
= 10

| (typ try MyEmpty)
| (typ (mytype try) (MyCons try))
| (def try () 1)
| (def try' (try _) try)
> (try' 10 try)
= 10

| (typ undefined MyEmpty)
| (typ (mytype undefined) (MyCons undefined))
| (def undefined () 1)
| (def undefined' (undefined _) undefined)
> (undefined' 10 undefined)
= 10

| (typ val MyEmpty)
| (typ (mytype val) (MyCons val))
| (def val () 1)
| (def val' (val _) val)
> (val' 10 val)
= 10

| (typ value MyEmpty)
| (typ (mytype value) (MyCons value))
| (def value () 1)
| (def value' (value _) value)
> (value' 10 value)
= 10

| (typ virtual MyEmpty)
| (typ (mytype virtual) (MyCons virtual))
| (def virtual () 1)
| (def virtual' (virtual _) virtual)
> (virtual' 10 virtual)
= 10

| (typ var MyEmpty)
| (typ (mytype var) (MyCons var))
| (def var () 1)
| (def var' (var _) var)
> (var' 10 var)
= 10

| (typ void MyEmpty)
| (typ (mytype void) (MyCons void))
| (def void () 1)
| (def void' (void _) void)
> (void' 10 void)
= 10

| (typ with MyEmpty)
| (typ (mytype with) (MyCons with))
| (def with () 1)
| (def with' (with _) with)
> (with' 10 with)
= 10

| (typ when MyEmpty)
| (typ (mytype when) (MyCons when))
| (def when () 1)
| (def when' (when _) when)
> (when' 10 when)
= 10

| (typ while MyEmpty)
| (typ (mytype while) (MyCons while))
| (def while () 1)
| (def while' (while _) while)
> (while' 10 while)
= 10

| (typ where MyEmpty)
| (typ (mytype where) (MyCons where))
| (def where () 1)
| (def where' (where _) where)
> (where' 10 where)
= 10

| (typ quot MyEmpty)
| (typ (mytype quot) (MyCons quot))
| (def quot () 1)
| (def quot' (quot _) quot)
> (quot' 10 quot)
= 10

| (typ yield MyEmpty)
| (typ (mytype yield) (MyCons yield))
| (def yield () 1)
| (def yield' (yield _) yield)
> (yield' 10 yield)
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
