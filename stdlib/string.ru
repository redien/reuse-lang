
(import stdlib/list.ru)
(import stdlib/math.ru)

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



(export string:decimal-string-from-integer (lambda (original-integer)
    (define (min-value-string (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:new) 45) 50) 49) 52) 55) 52) 56) 51) 54) 52) 56))
    (define (min-value (- (- 0 2147483647) 1))
        (if (== original-integer min-value)
            min-value-string
            (define (string (string:new))
            (define (prefixed-string (if (< original-integer 0) (string:push string 45) string))
            (define (original-integer (if (< original-integer 0) (- 0 original-integer) original-integer))
            (define (decimal-string-from-integer-with-accumulators (lambda (integer string exponent factor)
                (if (== exponent 0)
                    (if (== (string:length string) 0) (string:push string 48) string)
                    (define (new-factor (/ integer exponent))
                    (define (new-integer (- integer (* new-factor exponent)))
                    (define (new-exponent (/ exponent 10))
                    (define (new-string (if (!= original-integer new-integer) (string:push string (+ 48 new-factor)) string))
                        (self new-integer new-string new-exponent new-factor))))))))
            (decimal-string-from-integer-with-accumulators original-integer prefixed-string 1000000000 0))))))))))

(export string:integer-from-decimal-string (lambda (string)
    (define (length (string:length string))
    (define (negativity-factor (if (== (string:code-point-at-index string 0) 45) (- 0 1) 1))
    (define (start-index (if (== negativity-factor 1) 0 1))
    (define (integer-from-decimal-string-with-accumulator (lambda (string index exponent integer)
        (if (== index length)
            (* negativity-factor integer)
            (self string (+ index 1) (/ exponent 10) (+ integer (* exponent (- (string:code-point-at-index string index) 48)))))))
    (if (== length 0)
        0
        (define (exponent (math:pow 10 (- (- length start-index) 1)))
        (integer-from-decimal-string-with-accumulator string start-index exponent 0)))))))))
