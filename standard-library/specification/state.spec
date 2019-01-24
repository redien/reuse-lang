
state-lift
> (state-final-value Empty (state-lift (list 65)))
= A


state-return
> (state-final-value Empty (state-return (list 65)))
= A


state-map
> (state-final-value Empty (state-map list-from (state-lift 65)))
= A

> (state-final-value Empty \
                     (state-map (list-cons 66) \
                     (state-map (list-cons 65) \
                                (state-lift Empty))))
= BA


state-flatmap
> (state-final-value Empty (state-flatmap (pipe list-from state-lift) (state-lift 65)))
= A


state-bind
> (state-final-value Empty \
                     (state-bind   (state-lift 65) (fn (a) \
                     (state-bind   (state-lift 66) (fn (b) \
                     (state-return (list a b)))))))
= AB


state-get & state-set
> (state-final-value 0 \
                     (state-bind   (state-get)             (fn (count) \
                     (state-bind   (state-set (+ count 1)) (fn (new-count) \
                     (state-return (list (+ 65 new-count))))))))
= B

> (state-final-value (list 65) \
                     (state-bind   (state-get)                  (fn (s) \
                     (state-bind   (state-set (list-cons 66 s)) (fn (s) \
                     (state-bind   (state-set (list-cons 67 s)) (fn (s) \
                     (state-return s))))))))
= CBA

state-let
> (state-final-value 2 \
                     (state-bind   (state-get)                  (fn (count) \
                     (state-let    40                           (fn (number) \
                     (state-bind   (state-set (+ count number)) (fn (new-count) \
                     (state-return (list (+ 65 new-count))))))))))
= k