
Should parse identifiers
> (def _ () f)
= (def _ () f)

> (def _ () identifier)
= (def _ () identifier)


Should parse identifier exports
> (export a)
= (export a)

> (export a b c)
= (export a b c)

> (export some-long-name)
= (export some-long-name)
