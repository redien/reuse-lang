read_stdin = do
        input <- getContents
        evaluate $ force input

int32_to_char :: Int32 -> Prelude.Char
int32_to_char !i = toEnum (fromIntegral i)

str_cons !x !xs =
        concat [xs, [int32_to_char x]]

char_to_int32 :: Prelude.Char -> Int32
char_to_int32 !c = fromIntegral (fromEnum c)

string_to_reuse_string !s =
        foldl (\ !s !c -> string_append (char_to_int32 c) s) string_empty s

stdin_get :: (Int32 -> a) -> a -> Prelude.String -> Int32 -> a
stdin_get !succ !fail !s !index =
        let !i = fromIntegral index in
        if i < (length s) && i >= 0 then
                succ (char_to_int32 (s !! i))
        else
                fail

list_to_string = string_foldl str_cons ""
stdin_list = do
        stdin_string <- read_stdin
        return stdin_string

hs_string_next !iterable =
    case iterable of
        (Pair2 !s !index) -> (Pair2
            (stdin_get (\ !x -> Some x) None s index)
            (Pair2 s (index + 1)))

hs_string_to_indexed_iterator s = indexed_iterator_from_iterable (IterableClass hs_string_next) (Pair2 s 0)
