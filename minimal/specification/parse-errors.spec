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
