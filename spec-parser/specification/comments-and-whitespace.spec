
Test cases can have arbitrary whitespace between them
> > expression
> = expected
> 
> > expression2
> = expected2
= ExpectSuccess:expected=expected,expression=expression|ExpectSuccess:expected=expected2,expression=expression2

Lines with arbitrary text are comments
> this is a comment
> > expression
> so is this
> = expected
> and this
= Comment:this is a comment|Comment:so is this|ExpectSuccess:expected=expected,expression=expression|Comment:and this

Empty lines are ignored
> 
> > expression
> 
> = expected
> 
= ExpectSuccess:expected=expected,expression=expression
