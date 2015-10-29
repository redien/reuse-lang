
(import stdlib/list.ru)

(export vector:new (lambda ()
    (cons 0 nil)))

(export vector:length (lambda (vector)
    (first vector)))

(export vector:push (lambda (vector value)
    (cons
        (+ 1 (first vector))
        (cons value (rest vector)))))

(export vector:pop (lambda (vector)
    (cons
        (- (first vector) 1)
        (rest (rest vector)))))

(export vector:element-at-index (lambda (vector index)
    (first
        (list:take-last
            (rest vector)
            (+ index 1)))))

(export vector:last-element (lambda (vector)
    (first (rest vector))))
