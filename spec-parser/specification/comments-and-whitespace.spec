
Test cases can have arbitrary whitespace between them
> > expression
> = expected
> 
> > expression2
> = expected2
= expected=expected,expression=expression|expected=expected2,expression=expression2

Lines with arbitrary text are ignored
> this is ignored
> > expression
> so is this
> = expected
> and this
= expected=expected,expression=expression
