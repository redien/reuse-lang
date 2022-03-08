
Should parse a simple test case
> > expression
> = expected
= ExpectSuccess:expected=expected,expression=expression

Should parse several test cases
> > expression
> = expected
> > expression2
> = expected2
= ExpectSuccess:expected=expected,expression=expression|ExpectSuccess:expected=expected2,expression=expression2
