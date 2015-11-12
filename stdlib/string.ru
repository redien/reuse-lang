(comment

 reuse-lang - a pure functional lisp-like language for writing
 reusable algorithms in an extremely portable way.

 Written in 2015 by Jesper Oskarsson jesosk@gmail.com

 To the extent possible under law, the author(s) have dedicated all copyright
 and related and neighboring rights to this software to the public domain worldwide.
 This software is distributed without any warranty.

 You should have received a copy of the CC0 Public Domain Dedication along with this software.
 If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

)

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



(comment Functions below are not dependent on the implementation above using
    lists. It can thus be used even if the above functions are implemented
    as the language's native data types.)

(import stdlib/math.ru)

(export string:substring (lambda (string start length)
    (if (< length 0)
        (string:new)
        (let (string-length (string:length string))
        (let (substring-with-accumulator (lambda (string offset length new-string)
            (if (or (== length 0) (>= offset string-length))
                new-string
                (self string (+ offset 1) (- length 1) (string:push new-string (string:code-point-at-index string offset))))))
        (substring-with-accumulator string start length (string:new)))))))

(export string:equal? (lambda (first-string second-string)
    (let (code-point-equal? (lambda (first-string second-string index)
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
    (let (min-value-string (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:push (string:new) 45) 50) 49) 52) 55) 52) 56) 51) 54) 52) 56))
    (let (min-value (- (- 0 2147483647) 1))
        (if (== original-integer min-value)
            min-value-string
            (let (string (string:new))
            (let (prefixed-string (if (< original-integer 0) (string:push string 45) string))
            (let (original-integer (if (< original-integer 0) (- 0 original-integer) original-integer))
            (let (decimal-string-from-integer-with-accumulators (lambda (integer string exponent factor)
                (if (== exponent 0)
                    (if (== (string:length string) 0) (string:push string 48) string)
                    (let (new-factor (/ integer exponent))
                    (let (new-integer (- integer (* new-factor exponent)))
                    (let (new-exponent (/ exponent 10))
                    (let (new-string (if (!= original-integer new-integer) (string:push string (+ 48 new-factor)) string))
                        (self new-integer new-string new-exponent new-factor))))))))
            (decimal-string-from-integer-with-accumulators original-integer prefixed-string 1000000000 0))))))))))

(export string:integer-from-decimal-string (lambda (string)
    (let (length (string:length string))
    (let (negativity-factor (if (== (string:code-point-at-index string 0) 45) (- 0 1) 1))
    (let (start-index (if (== negativity-factor 1) 0 1))
    (let (integer-from-decimal-string-with-accumulator (lambda (string index exponent integer)
        (if (== index length)
            (* negativity-factor integer)
            (self string (+ index 1) (/ exponent 10) (+ integer (* exponent (- (string:code-point-at-index string index) 48)))))))
    (if (== length 0)
        0
        (let (exponent (math:pow 10 (- (- length start-index) 1)))
        (integer-from-decimal-string-with-accumulator string start-index exponent 0)))))))))
