
Test cases can have arbitrary whitespace between them
> > expression
> = expected
> 
> > expression2
> = expected2
= ExpectSuccess:expected=expected,expression=expression|ExpectSuccess:expected=expected2,expression=expression2

Lines with arbitrary text are ignored
> this is ignored
> > expression
> so is this
> = expected
> and this
= ExpectSuccess:expected=expected,expression=expression
