
(export math:pow (lambda (base exponent)
    (define (pow-with-accumulator (lambda (base exponent accumulator)
        (if (== exponent 0)
            accumulator
            (self base (- exponent 1) (* base accumulator)))))
    (if (== base 0)
        0
        (pow-with-accumulator base exponent 1)))))
