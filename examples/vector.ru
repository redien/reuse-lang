
(import stdlib/vector.ru)

(export length_of_some_list (lambda ()
    (vector:length (vector:push (vector:new) 42))))
