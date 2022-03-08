
Should parse a context
> | context
> > expression
> = expected
= ExpectSuccess:expected=expected,expression=expression,context=context

It should be possible to put the context anywhere before the assertion
> > expression
> | context
> = expected
= ExpectSuccess:expected=expected,expression=expression,context=context

The context should also be parsed for failure assertions
> | context
> > expression
> ? expected
= ExpectFailure:expected=expected,expression=expression,context=context
