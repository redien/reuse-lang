import Test.QuickCheck
import Test.QuickCheck.Modifiers (NonEmptyList (..))
import Data.Int
import qualified Data.Char as Char
import qualified ReuseStdlib as Reuse
import Conversions

prop_isomorphic :: String -> Bool
prop_isomorphic xs = string_to_hs (string_to_reuse xs) == xs

prop_string_first :: NonEmptyList Char -> Bool
prop_string_first (NonEmpty s) = maybe_to_hs (Reuse.maybe_45map (Char.chr . fromIntegral) (Reuse.string_45first (string_to_reuse s))) == Just (head s)

prop_string_rest :: NonEmptyList Char -> Bool
prop_string_rest (NonEmpty s) = string_to_hs (Reuse.string_45rest (string_to_reuse s)) == tail s

prop_string_size :: String -> Bool
prop_string_size s = (fromIntegral . Reuse.string_45size . string_to_reuse) s == length s

prop_string_concat :: String -> String -> Bool
prop_string_concat x y = string_to_hs (Reuse.string_45concat (string_to_reuse x) (string_to_reuse y)) == x ++ y

prop_string_every :: Fun Int Bool -> String -> Bool
prop_string_every (Fn f) xs = bool_to_hs (Reuse.string_45every_63 (bool_to_reuse . f . fromIntegral) (string_to_reuse xs)) == all (f . Char.ord) xs

prop_string_any :: Fun Int Bool -> String -> Bool
prop_string_any (Fn f) xs = bool_to_hs (Reuse.string_45any_63 (bool_to_reuse . f . fromIntegral) (string_to_reuse xs)) == any (f . Char.ord) xs

prop_string_to_int32 :: Int32 -> Bool
prop_string_to_int32 x = (maybe_to_hs . Reuse.string_45to_45int32 . string_to_reuse . show) x == Just x

prop_string_from_int32 :: Int32 -> Bool
prop_string_from_int32 x = (string_to_hs . Reuse.string_45from_45int32) x == show x

quickCheckN f = quickCheck (withMaxSuccess 1000 f)

main = do
    quickCheckN prop_isomorphic
    quickCheckN prop_string_first
    quickCheckN prop_string_rest
    quickCheckN prop_string_size
    quickCheckN prop_string_concat
    quickCheckN prop_string_every
    quickCheckN prop_string_any
    quickCheckN prop_string_to_int32
