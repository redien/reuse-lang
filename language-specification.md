
# Reuse language specification

## Type system

#### Monotypes

| Type    | Description                  | Example Values                                  |
|---------|------------------------------|-------------------------------------------------|
| integer | arbitrary precision integer  | `-1`, `12345678912345678912345678912345` or `0` |
| string  | string of UTF-8 encoded text | `""`, `"abc"` or `"也称乱数假文或者哑元文本"`       |
| boolean | boolean type                 | `true` or `false`                               |

#### Polytypes

| Type   | Description                                | Constructor                 |
|--------|--------------------------------------------|-----------------------------|
| list A | recursive product type of `A` and `list A` | `(list head tail)` or `nil` |

#### Composing types

| Type        | Description                 |
|-------------|-----------------------------|
| sum A B     | sum type of `A` or `B`      |
| product A B | product type of `A` and `B` |
| alias A     | alias of `A`                |

#### Defining types

```clojure
(sum (list a) (cons a list)
              empty)

(define reverse (lambda (list)
    (_reverse list (empty))))

(define _reverse (lambda (list accumulator)
    (match list
        empty (empty)
        (cons head tail) (_reverse tail (cons head accumulator)))))

(define map (lambda (function list)
    (reverse (_map function list (empty)))))

(define _map (lambda (function list accumulator)
    (match list
        empty (empty)
        (cons head tail) (_map function tail (cons (function head) accumulator)))))

(product (token) string integer)
(alias (token-list) (list token))
(sum (result) (error string)
              (value token-list))

(define stringify-token-list (lambda (tokens)
    (map (lambda (token)
        (match token
            (token value line-number) (concat value (integer-to-string line-number))))
    tokens)))
```
