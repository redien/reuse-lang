
Type definitions with a single constructor should be kept on one line
> (typ a A)
= 
= (typ a A)
= 

> (typ a (A a))
= 
= (typ a (A a))
= 

Type definitions with multiple constructors should have the constructors on individual lines
> (typ ab A B)
= 
= (typ ab
=      A
=      B)
= 

Type definitions with complex constructors should keep them on one line
> (typ ab A (B ab))
= 
= (typ ab
=      A
=      (B ab))
= 

Type definitions with type arguments should keep them on the first line
> (typ (a x) (A x))
= 
= (typ (a x) (A x))
= 

> (typ (a x) (A x) B)
= 
= (typ (a x)
=      (A x)
=      B)
= 

Should format existential type parameters
> (typ (a (exists x)) (A x))
= 
= (typ (a (exists x)) (A x))
= 

Function types should be formatted on one line
> (typ a (A (fn (a a) a)))
= 
= (typ a (A (fn (a a) a)))
= 

Complex types should be formatted on one line
> (typ (a x) (A x)) (typ b (B (a b)))
= 
= (typ (a x) (A x))
=
= (typ b (B (a b)))
= 

> (typ (a x) (A x)) (typ b (B (a b)) C)
= 
= (typ (a x) (A x))
=
= (typ b
=      (B (a b))
=      C)
= 

Complex types should be formatted with one type per line of when constructor is 80 characters or longer
> (typ a (Foo abcdefghijklmnopqrstabcdefghijklmnopq rstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ123))
= 
= (typ a
=      (Foo abcdefghijklmnopqrstabcdefghijklmnopq
=           rstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ123))
=

> (typ a (Foo abcdefghijklmnopqrstabcdefghijklmnopq rstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ12))
= 
= (typ a (Foo abcdefghijklmnopqrstabcdefghijklmnopq rstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ12))
=

Type definitions with public modifier
> (pub typ a A)
= 
= (pub typ a A)
= 

Type definitions with multiple constructors should have the constructors on individual lines
> (pub typ ab A B)
= 
= (pub typ ab
=      A
=      B)
= 
