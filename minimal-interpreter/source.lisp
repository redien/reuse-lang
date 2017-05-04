(data (list a) Empty (Cons a (list a)))
(def eval (string) (match string (Cons x xs) x Empty -1))
