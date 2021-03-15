{-# LANGUAGE DeriveGeneric #-}
import Debug.Trace
import GHC.Generics
import Test.QuickCheck
import Test.QuickCheck.Modifiers (NonEmptyList (..))
import Data.Int
import Data.List
import qualified Data.Char as Char
import qualified ReuseStdlib as Reuse
import Conversions

data ReuseString
    = SEmpty
    | SAppend Char ReuseString
    | SPrepend Char ReuseString
    | SSkip Int32 ReuseString
    | STake Int32 ReuseString
    | SJoin ReuseString [ReuseString]
    | SReverse ReuseString
    | SRest ReuseString
    | SConcat ReuseString ReuseString
    deriving Generic

instance Show ReuseString where
    show SEmpty = "(string-empty)"
    show (SAppend x xs) = "(string-append " ++ (show (Char.ord x)) ++ " " ++ (show xs) ++ ")"
    show (SPrepend x xs) = "(string-prepend " ++ (show (Char.ord x)) ++ " " ++ (show xs) ++ ")"
    show (SSkip x xs) = "(string-skip " ++ (show x) ++ " " ++ (show xs) ++ ")"
    show (STake x xs) = "(string-take " ++ (show x) ++ " " ++ (show xs) ++ ")"
    show (SJoin sep xs) = "(string-join " ++ (show sep) ++ " " ++ (show xs) ++ ")"
    show (SReverse xs) = "(string-reverse " ++ (show xs) ++ ")"
    show (SRest xs) = "(string-rest " ++ (show xs) ++ ")"
    show (SConcat xs ys) = "(string-concat " ++ (show xs) ++ " " ++ (show ys) ++ ")"

emptyGen :: Gen ReuseString
emptyGen = return SEmpty

appendGen :: Int -> Gen ReuseString
appendGen n = do
    x <- arbitrary
    xs <- arbitraryReuseString (n - 1)
    return (SAppend x xs)

prependGen :: Int -> Gen ReuseString
prependGen n = do
    x <- arbitrary
    xs <- arbitraryReuseString (n - 1)
    return (SPrepend x xs)

skipGen :: Int -> Gen ReuseString
skipGen n = do
    x <- arbitrary
    xs <- arbitraryReuseString (n - 1)
    return (SSkip x xs)

takeGen :: Int -> Gen ReuseString
takeGen n = do
    x <- arbitrary
    xs <- arbitraryReuseString (n - 1)
    return (STake x xs)

joinGen :: Int -> Gen ReuseString
joinGen n = do
    k <- choose (1, n)
    sep <- arbitraryReuseString (n `div` k)
    xs <- sequence [ arbitraryReuseString (n `div` k)  | _ <- [1..k] ]
    return (SJoin sep xs)

reverseGen :: Int -> Gen ReuseString
reverseGen n = do
    xs <- arbitraryReuseString (n - 1)
    return (SReverse xs)

restGen :: Int -> Gen ReuseString
restGen n = do
    xs <- arbitraryReuseString (n - 1)
    return (SRest xs)

concatGen :: Int -> Gen ReuseString
concatGen n = do
    xs <- arbitraryReuseString (n `div` 2)
    ys <- arbitraryReuseString (n `div` 2)
    return (SConcat xs ys)

arbitraryReuseString :: Int -> Gen ReuseString
arbitraryReuseString 0 = emptyGen
arbitraryReuseString n = oneof [appendGen n, prependGen n, skipGen n, takeGen n, joinGen n, reverseGen n, restGen n, concatGen n]

instance Arbitrary ReuseString where
    arbitrary = do
        x <- oneof [arbitraryReuseString 1, arbitraryReuseString 2, arbitraryReuseString 3, sized arbitraryReuseString]
        return x
    shrink x = shrinkToNil x ++ genericShrink x
        where
            shrinkToNil SEmpty = []
            shrinkToNil _ = [SEmpty]

charToInt = fromIntegral . Char.ord

evalReuse :: ReuseString -> Reuse.String
evalReuse SEmpty = Reuse.string_empty
evalReuse (SAppend x xs) = Reuse.string_append (charToInt x) (evalReuse xs)
evalReuse (SPrepend x xs) = Reuse.string_prepend (charToInt x) (evalReuse xs)
evalReuse (SSkip x xs) = Reuse.string_skip x (evalReuse xs)
evalReuse (STake x xs) = Reuse.string_take x (evalReuse xs)
evalReuse (SJoin x xs) = Reuse.string_join (evalReuse x) (list_to_reuse (map evalReuse xs))
evalReuse (SReverse xs) = Reuse.string_reverse (evalReuse xs)
evalReuse (SRest xs) = Reuse.string_rest (evalReuse xs)
evalReuse (SConcat xs ys) = Reuse.string_concat (evalReuse xs) (evalReuse ys)

evalHs :: ReuseString -> String
evalHs SEmpty = ""
evalHs (SAppend x xs) = (evalHs xs) ++ [x]
evalHs (SPrepend x xs) = [x] ++ (evalHs xs)
evalHs (SSkip x xs) = drop (fromIntegral x) (evalHs xs)
evalHs (STake x xs) = take (fromIntegral x) (evalHs xs)
evalHs (SJoin x xs) = intercalate (evalHs x) (map evalHs xs)
evalHs (SReverse xs) = reverse (evalHs xs)
evalHs (SRest xs) = (if length s == 0 then "" else tail s) where s = (evalHs xs)
evalHs (SConcat xs ys) = (evalHs xs) ++ (evalHs ys)

prop_isomorphic :: String -> Bool
prop_isomorphic xs = string_to_hs (string_to_reuse xs) == xs

prop_equivalence :: ReuseString -> Bool
prop_equivalence xs = string_to_hs (evalReuse xs) == evalHs xs

prop_string_first :: NonEmptyList Char -> Bool
prop_string_first (NonEmpty s) = maybe_to_hs (Reuse.maybe_map (Char.chr . fromIntegral) (Reuse.string_first (string_to_reuse s))) == Just (head s)

prop_string_size :: String -> Bool
prop_string_size s = (fromIntegral . Reuse.string_size . string_to_reuse) s == length s

prop_string_every :: Fun Int Bool -> String -> Bool
prop_string_every (Fn f) xs = bool_to_hs (Reuse.string_every (bool_to_reuse . f . fromIntegral) (string_to_reuse xs)) == all (f . Char.ord) xs

prop_string_any :: Fun Int Bool -> String -> Bool
prop_string_any (Fn f) xs = bool_to_hs (Reuse.string_any (bool_to_reuse . f . fromIntegral) (string_to_reuse xs)) == any (f . Char.ord) xs

prop_string_to_int32 :: Int32 -> Bool
prop_string_to_int32 x = (maybe_to_hs . Reuse.string_to_int32 . string_to_reuse . show) x == Just x

prop_string_from_int32 :: Int32 -> Bool
prop_string_from_int32 x = (string_to_hs . Reuse.string_from_int32) x == show x

quickCheckN f = quickCheck (withMaxSuccess 1000 f)

main = do
    quickCheckN prop_isomorphic
    quickCheck (withMaxSuccess 100000 prop_equivalence)
    quickCheckN prop_string_first
    quickCheckN prop_string_size
    quickCheckN prop_string_every
    quickCheckN prop_string_any
    quickCheckN prop_string_to_int32
