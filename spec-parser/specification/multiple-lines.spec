
Expression should accept several lines
> > expr
> > ession
> = expected
= ExpectSuccess:expected=expected,expression=expr
= ession

Expression should accept empty lines
> > 
> > expr
> > 
> > ession
> > 
> = expected
= ExpectSuccess:expected=expected,expression=
= expr
= 
= ession
= 

Assertion should accept several lines
> > expression
> = expe
> = cted
= ExpectSuccess:expected=expe
= cted,expression=expression

Assertion should accept empty lines
> > expression
> = 
> = expe
> = 
> = cted
> = 
= ExpectSuccess:expected=
= expe
= 
= cted
= ,expression=expression

Failure assertion should accept several lines
> > expression
> ? expe
> ? cted
= ExpectFailure:expected=expe
= cted,expression=expression

Failure assertion should accept empty lines
> > expression
> ? 
> ? expe
> ? 
> ? cted
> ? 
= ExpectFailure:expected=
= expe
= 
= cted
= ,expression=expression

Context should accept several lines
> | con
> | text
> > expression
> = expected
= ExpectSuccess:expected=expected,expression=expression,context=con
= text

Context should accept empty lines
> | 
> | con
> | 
> | text
> | 
> > expression
> = expected
= ExpectSuccess:expected=expected,expression=expression,context=
= con
= 
= text
= 
