
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

There should be several different contexts
> | context1
> / context2
> \ context3
> > expression
> = expected
= ExpectSuccess:expected=expected,expression=expression,context=context1,context2=context2,context3=context3

The order of the contexts shouldn't matter
> | context1
> \ context3
> / context2
> > expression
> = expected
= ExpectSuccess:expected=expected,expression=expression,context=context1,context2=context2,context3=context3
