
It should be possible to access functions across modules
/ (pub def foo () 1)
| (def bar () (foo))
> (bar)
= 1

Should return an error if a private function is called outside of its module
/ (def foo () 1)
| (def bar () (foo))
> (bar)
? The following identifier is not accessible from this module: foo

It should be possible to access constructors across modules
/ (pub typ foo (Foo int32))
| (def bar () (Foo 2))
> (match (bar) (Foo x) x)
= 2

Should return an error if a private constructor is used outside of its module
/ (typ foo (Foo int32))
| (def bar () (Foo 1))
> (match (bar) (Foo x) x)
? The following identifier is not accessible from this module: Foo

It should be possible to access types across modules
/ (pub typ foo (Foo int32))
| (typ bar (Bar foo))
| (def foobar () (Bar (Foo 3)))
> (match (foobar) (Bar (Foo x)) x)
= 3

Should return an error if a private type is used outside of its module
/ (typ foo (Foo int32))
| (typ bar (Bar foo))
| (def foobar () (Bar (Foo 3)))
> (match (foobar) (Bar (Foo x)) x)
? The following identifier is not accessible from this module: foo
