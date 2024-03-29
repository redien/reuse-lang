
Should parse the simplest function
> (def constant () 1)
= (def constant () 1)

Should parse function arguments
> (def _ (a) 1)
= (def _ (a) 1)

> (def _ (a b c) 1)
= (def _ (a b c) 1)

Should parse public functions
> (pub def constant () 1)
= (pub def constant () 1)

Should return an error given a function without a name
> (def)
? FunctionDefinitionMissingName

> (def ())
? FunctionDefinitionMissingName

> (pub def)
? FunctionDefinitionMissingName

> (pub def ())
? FunctionDefinitionMissingName
