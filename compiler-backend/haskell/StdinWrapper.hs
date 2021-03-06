{-# LANGUAGE BangPatterns #-}
module StdinWrapper where

import Data.Maybe
import Data.Int
import Data.List
import Data.Char
import Control.Exception
import Control.DeepSeq
import Reuse

read_stdin = do
        input <- getContents
        evaluate $ force input

int32_to_char :: Int32 -> Char
int32_to_char !i = toEnum (fromIntegral i)

str_cons !x !xs =
        concat [xs, [int32_to_char x]]

char_to_int32 :: Char -> Int32
char_to_int32 !c = fromIntegral (fromEnum c)

string_to_reuse_string !s =
        foldl (\ !s !c -> string_append (char_to_int32 c) s) string_empty s

stdin_get :: (Int32 -> a) -> a -> String -> Int32 -> a
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
        (CPair !s !index) -> (CPair
            (stdin_get (\ !x -> CSome x) CNone s index)
            (CPair s (index + 1)))

hs_string_to_indexed_iterator s = indexed_iterator_from_iterable (CIterableClass hs_string_next) (CPair s 0)
