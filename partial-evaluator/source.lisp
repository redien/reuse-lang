(data (list a) Empty
               (Pair a (list a)))

(data (token a b) (Symbol (list a))
                  (Int32 b)
                  OpenBracket
                  CloseBracket)

(def tokenize (string)
    string)

(export main (string)
        (tokenize string))
