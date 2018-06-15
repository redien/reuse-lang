Should return an error given one too few closing brackets
> (
? There are too few closing parentheses

Should return an error given one too many closing brackets
> ())
? There are too many closing parentheses


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
