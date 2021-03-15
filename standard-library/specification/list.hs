{-# LANGUAGE DeriveGeneric #-}
import Debug.Trace
import GHC.Generics
import Test.QuickCheck
import Test.QuickCheck.Modifiers (NonEmptyList (..))
import Data.Int
import Data.List
import Data.List.GroupBy
import qualified ReuseStdlib as Reuse
import Conversions

data ReuseList
    = LEmpty
    | LCons Int32 ReuseList
    | LRest ReuseList
    | LSkip Int32 ReuseList
    | LTake Int32 ReuseList
    | LReverse ReuseList
    | LConcat ReuseList ReuseList
    | LMap (Fun Int32 Int32) ReuseList
    | LFilter (Fun Int32 Bool) ReuseList
    deriving Generic

instance Show ReuseList where
    show LEmpty = "(list-empty)"
    show (LCons x xs) = "(list-cons " ++ (show x) ++ " " ++ (show xs) ++ ")"
    show (LRest xs) = "(list-rest " ++ (show xs) ++ ")"
    show (LSkip x xs) = "(list-skip " ++ (show x) ++ " " ++ (show xs) ++ ")"
    show (LTake x xs) = "(list-take " ++ (show x) ++ " " ++ (show xs) ++ ")"
    show (LReverse xs) = "(list-reverse " ++ (show xs) ++ ")"
    show (LConcat xs ys) = "(list-concat " ++ (show xs) ++ " " ++ (show ys) ++ ")"
    show (LMap f xs) = "(list-map " ++ (show f) ++ " " ++ (show xs) ++ ")"
    show (LFilter f xs) = "(list-filter " ++ (show f) ++ " " ++ (show xs) ++ ")"

emptyGen :: Gen ReuseList
emptyGen = return LEmpty

consGen :: Int -> Gen ReuseList
consGen n = do
    x <- arbitrary
    xs <- arbitraryReuseList (n - 1)
    return (LCons x xs)

restGen :: Int -> Gen ReuseList
restGen n = do
    xs <- arbitraryReuseList (n - 1)
    return (LRest xs)

skipGen :: Int -> Gen ReuseList
skipGen n = do
    x <- arbitrary
    xs <- arbitraryReuseList (n - 1)
    return (LSkip x xs)

takeGen :: Int -> Gen ReuseList
takeGen n = do
    x <- arbitrary
    xs <- arbitraryReuseList (n - 1)
    return (LTake x xs)

reverseGen :: Int -> Gen ReuseList
reverseGen n = do
    xs <- arbitraryReuseList (n - 1)
    return (LReverse xs)

concatGen :: Int -> Gen ReuseList
concatGen n = do
    xs <- arbitraryReuseList (n `div` 2)
    ys <- arbitraryReuseList (n `div` 2)
    return (LConcat xs ys)

mapGen :: Int -> Gen ReuseList
mapGen n = do
    f <- arbitrary
    xs <- arbitraryReuseList (n - 1)
    return (LMap f xs)

filterGen :: Int -> Gen ReuseList
filterGen n = do
    f <- arbitrary
    xs <- arbitraryReuseList (n - 1)
    return (LFilter f xs)

arbitraryReuseList :: Int -> Gen ReuseList
arbitraryReuseList 0 = emptyGen
arbitraryReuseList n = frequency [(10, consGen n), (2, restGen n), (1, skipGen n), (1, takeGen n), (3, reverseGen n), (5, concatGen n), (2, mapGen n), (1, filterGen n)]

instance Arbitrary ReuseList where
    arbitrary = do
        x <- oneof [arbitraryReuseList 1, arbitraryReuseList 2, arbitraryReuseList 3, sized arbitraryReuseList]
        return x
    shrink x = shrinkToNil x ++ genericShrink x
        where
            shrinkToNil LEmpty = []
            shrinkToNil _ = [LEmpty]

evalReuse :: ReuseList -> Reuse.List Int32
evalReuse LEmpty = Reuse.list_empty
evalReuse (LCons x xs) = Reuse.list_cons x (evalReuse xs)
evalReuse (LRest xs) = Reuse.list_rest (evalReuse xs)
evalReuse (LSkip x xs) = Reuse.list_skip x (evalReuse xs)
evalReuse (LTake x xs) = Reuse.list_take x (evalReuse xs)
evalReuse (LReverse xs) = Reuse.list_reverse (evalReuse xs)
evalReuse (LConcat xs ys) = Reuse.list_concat (evalReuse xs) (evalReuse ys)
evalReuse (LMap (Fn f) xs) = Reuse.list_map f (evalReuse xs)
evalReuse (LFilter (Fn f) xs) = Reuse.list_filter (bool_to_reuse . f) (evalReuse xs)

evalHs :: ReuseList -> [Int32]
evalHs LEmpty = []
evalHs (LCons x xs) = x : (evalHs xs)
evalHs (LRest xs) = drop 1 (evalHs xs)
evalHs (LSkip x xs) = drop (fromIntegral x) (evalHs xs)
evalHs (LTake x xs) = take (fromIntegral x) (evalHs xs)
evalHs (LReverse xs) = reverse (evalHs xs)
evalHs (LConcat xs ys) = (evalHs xs) ++ (evalHs ys)
evalHs (LMap (Fn f) xs) = map f (evalHs xs)
evalHs (LFilter (Fn f) xs) = filter f (evalHs xs)

prop_isomorphic :: [Int] -> Bool
prop_isomorphic xs = list_to_hs (list_to_reuse xs) == xs

prop_equivalence :: ReuseList -> Bool
prop_equivalence xs = list_to_hs (evalReuse xs) == evalHs xs

prop_list_from_range :: Small Int32 -> Small Int32 -> Bool
prop_list_from_range (Small a) (Small b) = list_to_hs (Reuse.list_from_range a b) == [a..(b - 1)]

prop_list_last :: NonEmptyList Int -> Bool
prop_list_last (NonEmpty xs) = maybe_to_hs (Reuse.list_last (list_to_reuse xs)) == Just (last xs)

prop_list_size :: [Int] -> Bool
prop_list_size xs = Reuse.list_size (list_to_reuse xs) == fromIntegral (length xs)

prop_list_foldl :: Fun (Int, Int) Int -> Int -> Small [Int] -> Bool
prop_list_foldl (Fn2 f) x (Small xs) = Reuse.list_foldl f x (list_to_reuse xs) == foldl f x xs

prop_list_flatten :: [[Int]] -> Bool
prop_list_flatten xs = list_to_hs (Reuse.list_flatten (list_list_to_reuse xs)) == concat xs

prop_list_split_at :: Small Int -> [Int] -> Bool
prop_list_split_at (Small n) xs = pair_list_to_hs (Reuse.list_split_at (fromIntegral n) (list_to_reuse xs)) == splitAt n xs

prop_list_partition_by :: Fun (Int, Int) Bool -> [Int] -> Bool
prop_list_partition_by (Fn2 f) xs = list_list_to_hs (Reuse.list_partition_by (\a b -> bool_to_reuse (f a b)) (list_to_reuse xs)) == Data.List.GroupBy.groupBy f xs

prop_list_every :: Fun Int Bool -> [Int] -> Bool
prop_list_every (Fn f) xs = bool_to_hs (Reuse.list_every (bool_to_reuse . f) (list_to_reuse xs)) == all f xs

prop_list_any :: Fun Int Bool -> [Int] -> Bool
prop_list_any (Fn f) xs = bool_to_hs (Reuse.list_any (bool_to_reuse . f) (list_to_reuse xs)) == any f xs

prop_list_zip :: [Int] -> [Int] -> Bool
prop_list_zip xs ys = list_pair_to_hs (Reuse.list_zip (list_to_reuse xs) (list_to_reuse ys)) == zip xs ys

quickCheckN f = quickCheck (withMaxSuccess 1000 f)

main = do
    quickCheckN prop_isomorphic
    quickCheck (withMaxSuccess 100000 prop_equivalence)
    quickCheckN prop_list_from_range
    quickCheckN prop_list_last
    quickCheckN prop_list_size
    quickCheckN prop_list_flatten
    quickCheckN prop_list_split_at
    quickCheckN prop_list_partition_by
    quickCheckN prop_list_every
    quickCheckN prop_list_any
    quickCheckN prop_list_zip
