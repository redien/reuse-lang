Should return an error given one too few closing brackets
> (
? There are too few closing parentheses

Should return an error given one too many closing brackets
> ())
? There are too many closing parentheses


Should return an error given a malformed definition
| a
> 1
? Only type- or function definitions can be in the top level of a file. You need to wrap expressions in a function

| ()
> 1
? Only type- or function definitions can be in the top level of a file. You need to wrap expressions in a function

| (a)
> 1
? Only type- or function definitions can be in the top level of a file. You need to wrap expressions in a function

| (a b)
> 1
? Only type- or function definitions can be in the top level of a file. You need to wrap expressions in a function


Should return an error given a malformed type definition
| (typ)
> 1
? I think you wanted to write a type definition, but it doesn't have the right shape. It should look like this:
? 
? (type name-of-type NameOfConstructor ...)
? 
? 

| (typ a)
> 1
? This type definition is missing a list of constructors. A type needs at least one constructor.


Should return an error given a malformed function definition
| (def)
> 1
? Malformed function definition found

| (def name)
> 1
? Malformed function definition found

| (def name ())
> 1
? Malformed function definition found

| (def name a)
> 1
? Malformed function definition found

| (def name () a b)
> 1
? Malformed function definition found


Should return an error given a malformed match expression
> (match 1)
? This match expression is not correct, make sure you have put parentheses correctly so that all your match rules come in pairs

> (match 1 x)
? This match expression is not correct, make sure you have put parentheses correctly so that all your match rules come in pairs

> (match 1 x 2 z)
? This match expression is not correct, make sure you have put parentheses correctly so that all your match rules come in pairs

> (match 1 () 1)
? I expected a pattern here but this doesn't look correct


Should return an error given an empty s-expression
> ()
? I expected an expression here but it doesn't contain anything
