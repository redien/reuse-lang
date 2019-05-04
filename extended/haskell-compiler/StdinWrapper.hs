module StdinWrapper where

import Data.Maybe
import Data.Int
import Data.List
import Data.Char
import Reuse

int32_to_char :: Int32 -> Char
int32_to_char i =
        chr (fromInteger (toInteger i))

string_cons x xs =
        concat [xs, [int32_to_char x]]

char_to_int32 :: Char -> Int32
char_to_int32 c =
        fromInteger (toInteger (fromEnum c))

string_to_reuse_string s =
        foldl (\s c -> string_45append (char_to_int32 c) s) string_45empty s

stdin_get :: (Int32 -> a) -> a -> String -> Int32 -> a
stdin_get succ fail s index =
        let i = fromInteger (toInteger index) in
        if i < (length s) && i >= 0 then
                succ (char_to_int32 (s !! i))
        else
                fail

list_to_string = string_45foldl string_cons ""
stdin_list = do
        stdin_string <- getContents
        return (indexed_45iterator_45from stdin_string (stdin_get (\x -> CSome x) CNone))
