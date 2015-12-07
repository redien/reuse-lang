
(import stdlib/string.ru)
(import ./lib/parse-tree.ru)

(define serialize-list (lambda (list child-index string)
    (if (< child-index (parse-tree:count list))
        (let (child (parse-tree:child list child-index))
        (let (serialized-child (parse-tree-serializer:serialize child))
        (recur
            list
            (+ child-index 1)
            (string:concatenate string (if (< child-index (- (parse-tree:count list) 1)) (string:push serialized-child 32) serialized-child)))))
        string)))

(export parse-tree-serializer:serialize (lambda (parse-tree)
    (if (parse-tree:list? parse-tree)
        (string:push (string:concatenate (string:push (string:new) 40) (serialize-list parse-tree 0 (string:new))) 41)
        (parse-tree:value parse-tree))))
