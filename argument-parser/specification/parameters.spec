
Parse single parameter
> --test true
= --test=true,

Parse two parameters
> --a x --b y
= --a=x,--b=y,

Parse several parameters
> --a x --b y --c z
= --a=x,--b=y,--c=z,

Parse empty key
> -- true
= --=true,

Parameter without value
> -test
= --test=true,

Two parameters without value
> -test -test2
= --test=true,--test2=true,

Several parameters without value
> -test -test2 -b
= --test=true,--test2=true,--b=true,
