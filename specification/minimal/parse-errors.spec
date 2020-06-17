Should return an error given one too few closing brackets
> (
? There are too few closing parentheses

Should return an error given one too many closing brackets
> ())
? There are too many closing parentheses


Should return an error given a malformed definition
| a
> 1
? Only type- or function definitions can be in the top level of a file. You need to wrap expressions in a function.

| ()
> 1
? Only type- or function definitions can be in the top level of a file. You need to wrap expressions in a function.

| (a)
> 1
? Only type- or function definitions can be in the top level of a file. You need to wrap expressions in a function.

| (a b)
> 1
? Only type- or function definitions can be in the top level of a file. You need to wrap expressions in a function.


Should return an error given a malformed type definition
| (typ)
> 1
? I think you wanted to write a type definition, but it doesn't have the right shape. It should look like this:\\n\\n(type name-of-type NameOfConstructor ...)\\n\\n

| (typ a)
> 1
? I think you wanted to write a type definition, but it doesn't have the right shape. It should look like this:\\n\\n(type name-of-type NameOfConstructor ...)\\n\\n


Should return an error given a malformed function definition
| (def)
> 1
? I think you wanted to write a function definition, but it doesn't have the right shape. It should look like this:\\n\\n(def name-of-function (arguments) expression)\\n\\n

| (def name)
> 1
? I think you wanted to write a function definition, but it doesn't have the right shape. It should look like this:\\n\\n(def name-of-function (arguments) expression)\\n\\n

| (def name ())
> 1
? I think you wanted to write a function definition, but it doesn't have the right shape. It should look like this:\\n\\n(def name-of-function (arguments) expression)\\n\\n

| (def name a)
> 1
? I think you wanted to write a function definition, but it doesn't have the right shape. It should look like this:\\n\\n(def name-of-function (arguments) expression)\\n\\n

| (def name () a b)
> 1
? I think you wanted to write a function definition, but it doesn't have the right shape. It should look like this:\\n\\n(def name-of-function (arguments) expression)\\n\\n


Should return an error given a malformed match expression
> (match 1)
? This match expression is not correct, make sure you have put parentheses correctly so that all your match rules come in pairs like this:\\n\\n(match e\\n       pattern1  e1\\n       pattern2  e2\\n       ...)\\n\\n

> (match 1 x)
? This match expression is not correct, make sure you have put parentheses correctly so that all your match rules come in pairs like this:\\n\\n(match e\\n       pattern1  e1\\n       pattern2  e2\\n       ...)\\n\\n

> (match 1 x 2 z)
? This match expression is not correct, make sure you have put parentheses correctly so that all your match rules come in pairs like this:\\n\\n(match e\\n       pattern1  e1\\n       pattern2  e2\\n       ...)\\n\\n
