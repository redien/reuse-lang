
Should parse composition special form
> (def _ (f) (. f))
= (def _ (f) (. f))

> (def _ (f) (. f f))
= (def _ (f) (. f f))

> (def _ (f) (. f f f))
= (def _ (f) (. f f f))

> (def _ (f g) (. f g))
= (def _ (f g) (. f g))

Should parse pipe special form
> (def _ (f) (pipe 1 f))
= (def _ (f) (pipe 1 f))

> (def _ (f) (pipe 1 f f))
= (def _ (f) (pipe 1 f f))

> (def _ (f) (pipe f f f))
= (def _ (f) (pipe f f f))

> (def _ (f g) (pipe 1 f g))
= (def _ (f g) (pipe 1 f g))
