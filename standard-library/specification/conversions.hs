{-# LANGUAGE DeriveGeneric #-}
module Conversions where
import qualified ReuseStdlib as Reuse
import qualified Data.Map as Map
import qualified Data.Char as Char
import Data.Int
import Data.Bifunctor
import System.Process
import Control.Concurrent
import System.Directory (removeFile)
import System.IO (hGetContents, hPutStr, hSeek, openBinaryTempFile, SeekMode (..))
import Test.QuickCheck
import GHC.Generics

data ReusePredicate
    = AlwaysTrue
    | AlwaysFalse
    | LessThan Int32
    deriving Generic

instance Show ReusePredicate where
    show AlwaysTrue = "(const True)"
    show AlwaysFalse = "(const False)"
    show (LessThan x) = "((flip <) " ++ (show x) ++ ")"

alwaysTrueGen :: Gen ReusePredicate
alwaysTrueGen = do
    return AlwaysTrue

alwaysFalseGen :: Gen ReusePredicate
alwaysFalseGen = do
    return AlwaysFalse

lessThanGen :: Int -> Gen ReusePredicate
lessThanGen n = do
    x <- arbitrary
    return (LessThan x)

arbitraryReusePredicate :: Int -> Gen ReusePredicate
arbitraryReusePredicate 0 = alwaysFalseGen
arbitraryReusePredicate n = frequency [(1, alwaysTrueGen), (1, lessThanGen n)]

instance Arbitrary ReusePredicate where
    arbitrary = do
        x <- oneof [arbitraryReusePredicate 1, arbitraryReusePredicate 2, arbitraryReusePredicate 3, sized arbitraryReusePredicate]
        return x
    shrink x = shrinkToNil x ++ genericShrink x
        where
            shrinkToNil AlwaysFalse = []
            shrinkToNil _ = [AlwaysFalse]

predReuse :: ReusePredicate -> Int32 -> Reuse.Boolean
predReuse AlwaysTrue = const Reuse.True
predReuse AlwaysFalse = const Reuse.False
predReuse (LessThan n) = \x -> bool_to_reuse $ x < n

predHs :: ReusePredicate -> Int32 -> Bool
predHs AlwaysTrue = const True
predHs AlwaysFalse = const False
predHs (LessThan n) = \x -> x < n


data ReuseUnaryFunction
    = UIdentity
    | UConst Int32
    deriving Generic

instance Show ReuseUnaryFunction where
    show UIdentity = "id"
    show (UConst x) = "(const " ++ (show x) ++ ")"

identityGen :: Gen ReuseUnaryFunction
identityGen = do
    return UIdentity

constGen :: Gen ReuseUnaryFunction
constGen = do
    x <- arbitrary
    return (UConst x)

arbitraryReuseUnaryFunction :: Int -> Gen ReuseUnaryFunction
arbitraryReuseUnaryFunction _ = oneof [identityGen, constGen]

instance Arbitrary ReuseUnaryFunction where
    arbitrary = do
        x <- oneof [arbitraryReuseUnaryFunction 1, arbitraryReuseUnaryFunction 2, arbitraryReuseUnaryFunction 3, sized arbitraryReuseUnaryFunction]
        return x
    shrink x = shrinkToNil x ++ genericShrink x
        where
            shrinkToNil UIdentity = []
            shrinkToNil _ = [UIdentity]

unaryReuse :: ReuseUnaryFunction -> Int32 -> Int32
unaryReuse UIdentity = id
unaryReuse (UConst x) = const x

unaryHs :: ReuseUnaryFunction -> Int32 -> Int32
unaryHs UIdentity = id
unaryHs (UConst x) = const x


evalExpr :: String -> String -> String -> IO String
evalExpr lang source expr = do
    (_, out, _, h) <- runInteractiveCommand $ "IMPL=" ++ lang ++ " SOURCE=" ++ source ++ " ./standard-library/eval.sh '' '" ++ expr ++ "'"
    waitForProcess h
    hGetContents out

list_to_reuse :: [a] -> Reuse.List a
list_to_reuse = foldr Reuse.list_cons Reuse.list_empty

list_list_to_reuse :: [[a]] -> Reuse.List (Reuse.List a)
list_list_to_reuse xs = Reuse.list_map list_to_reuse (list_to_reuse xs)

list_to_hs :: Reuse.List a -> [a]
list_to_hs = Reuse.list_foldr (:) []

list_list_to_hs :: Reuse.List (Reuse.List a) -> [[a]]
list_list_to_hs xs = map list_to_hs (list_to_hs xs)

pair_to_reuse :: (a, b) -> Reuse.Pair a b
pair_to_reuse (x, y) = Reuse.pair_cons x y

pair_to_hs :: Reuse.Pair a b -> (a, b)
pair_to_hs (Reuse.Pair2 x y) = (x, y)

pair_list_to_hs :: Reuse.Pair (Reuse.List a) (Reuse.List b) -> ([a], [b])
pair_list_to_hs p = pair_to_hs (Reuse.pair_bimap list_to_hs list_to_hs p)

list_pair_to_reuse :: [(a, b)] -> Reuse.List (Reuse.Pair a b)
list_pair_to_reuse xs = list_to_reuse (map pair_to_reuse xs)

list_pair_to_hs :: Reuse.List (Reuse.Pair a b) -> [(a, b)]
list_pair_to_hs xs = list_to_hs (Reuse.list_map pair_to_hs xs)

bool_to_hs :: Reuse.Boolean -> Bool
bool_to_hs b = case b of Reuse.True -> True ; Reuse.False -> False

bool_to_reuse :: Bool -> Reuse.Boolean
bool_to_reuse b = case b of True -> Reuse.True ; False -> Reuse.False

maybe_to_hs :: Reuse.Maybe a -> Maybe a
maybe_to_hs (Reuse.Some x) = Just x
maybe_to_hs Reuse.None = Nothing

string_to_reuse :: String -> Reuse.String
string_to_reuse s = foldl (\a b -> Reuse.string_append (fromIntegral (Char.ord b)) a) Reuse.string_empty s

string_to_hs :: Reuse.String -> String
string_to_hs s = Reuse.string_foldl (\a b -> b ++ [(Char.chr (fromIntegral a))]) "" s

dictionary_to_hs :: Reuse.Dictionary a -> Map.Map String a
dictionary_to_hs xs = Map.fromList (map (bimap string_to_hs id) (list_pair_to_hs (Reuse.dictionary_entries xs)))

dictionary_to_reuse :: Map.Map String a -> Reuse.Dictionary a
dictionary_to_reuse xs = Reuse.dictionary_of (list_pair_to_reuse (map (bimap string_to_reuse id) (Map.toList xs)))

array_to_hs :: Reuse.Array a -> Map.Map Int32 a
array_to_hs xs = Map.fromList (list_pair_to_hs (Reuse.array_entries xs))

array_to_reuse :: Map.Map Int32 a -> Reuse.Array a
array_to_reuse xs = Reuse.array_of (list_pair_to_reuse (Map.toList xs))

bigint_to_hs i = read (string_to_hs (Reuse.bigint_to_string i))
bigint_to_reuse i = Reuse.bigint_from_string (string_to_reuse (show i))
