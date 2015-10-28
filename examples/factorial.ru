
(export factorial
    (lambda (x)
        (define
            (factorial-tail
                (lambda (x accumulator)
                    (if (== x 1)
                        accumulator
                        (recur (- x 1) (* accumulator x)))))
            (factorial-tail x 1))))
