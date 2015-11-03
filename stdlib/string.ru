
(import stdlib/list.ru)

(export string:new (lambda ()
    (cons 0 nil)))

(export string:length (lambda (string)
    (first string)))

(export string:push (lambda (string code-point)
    (cons (+ (first string) 1) (cons code-point (rest string)))))

(export string:code-point-at-index (lambda (string index)
    (if (>= index (string:length string))
        0
        (first
            (list:take-last
                (rest string)
                (+ index 1))))))

(export string:concatenate (lambda (first-string second-string)
    (cons
        (+ (first first-string) (first second-string))
        (list:concatenate (rest second-string) (rest first-string)))))

(export string:substring (lambda (string start new-length)
    (define (offset-by (lambda (list n)
        (if (<= n 0)
            list
            (self (rest list) (- n 1)))))
    (define (length (string:length string))
    (define (end (if (> (+ start new-length) length) length (+ start new-length)))
    (define (start (if (> start length) length start))
    (define (new-length (if (< new-length 0) 0 (- end start)))
    (cons
        new-length
        (list:take
            (offset-by
                (rest string)
                (- (string:length string) end))
            new-length)))))))))

(export string:equal? (lambda (first-string second-string)
    (define (code-point-equal? (lambda (first-string second-string index)
                (if (< index (string:length first-string))
                    (if (==
                            (string:code-point-at-index first-string index)
                            (string:code-point-at-index second-string index))
                        (self first-string second-string (+ index 1))
                        false)
                    true)))
            (if (!= (string:length first-string) (string:length second-string))
                false
                (code-point-equal? first-string second-string 0)))))
