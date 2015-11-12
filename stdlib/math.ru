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

(export math:pow (lambda (base exponent)
    (let (pow-with-accumulator (lambda (base exponent accumulator)
        (if (== exponent 0)
            accumulator
            (self base (- exponent 1) (* base accumulator)))))
    (if (== base 0)
        0
        (pow-with-accumulator base exponent 1)))))
