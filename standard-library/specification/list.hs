import Test.QuickCheck
import Test.QuickCheck.Modifiers (NonEmptyList (..))
import Data.Int
import Data.List
import Data.List.GroupBy
import qualified ReuseStdlib as Reuse
import Conversions

prop_isomorphic :: [Int] -> Bool
prop_isomorphic xs = list_to_hs (list_to_reuse xs) == xs

prop_list_from_range :: Small Int32 -> Small Int32 -> Bool
prop_list_from_range (Small a) (Small b) = list_to_hs (Reuse.list_45from_45range a b) == [a..(b - 1)]

prop_list_last :: NonEmptyList Int -> Bool
prop_list_last (NonEmpty xs) = maybe_to_hs (Reuse.list_45last (list_to_reuse xs)) == Just (last xs)

prop_list_size :: [Int] -> Bool
prop_list_size xs = Reuse.list_45size (list_to_reuse xs) == fromIntegral (length xs)

prop_list_concat :: [Int] -> [Int] -> Bool
prop_list_concat xs ys = list_to_hs (Reuse.list_45concat (list_to_reuse xs) (list_to_reuse ys)) == xs ++ ys

prop_list_reverse :: [Int] -> Bool
prop_list_reverse xs = list_to_hs (Reuse.list_45reverse (list_to_reuse xs)) == reverse xs

prop_list_map :: Fun Int Int -> [Int] -> Bool
prop_list_map (Fn f) xs = list_to_hs (Reuse.list_45map f (list_to_reuse xs)) == map f xs

prop_list_foldl :: Fun (Int, Int) Int -> Int -> Small [Int] -> Bool
prop_list_foldl (Fn2 f) x (Small xs) = Reuse.list_45foldl f x (list_to_reuse xs) == foldl f x xs

prop_list_flatten :: [[Int]] -> Bool
prop_list_flatten xs = list_to_hs (Reuse.list_45flatten (list_list_to_reuse xs)) == concat xs

prop_list_split_at :: Small Int -> [Int] -> Bool
prop_list_split_at (Small n) xs = pair_list_to_hs (Reuse.list_45split_45at (fromIntegral n) (list_to_reuse xs)) == splitAt n xs

prop_list_partition_by :: Fun (Int, Int) Bool -> [Int] -> Bool
prop_list_partition_by (Fn2 f) xs = list_list_to_hs (Reuse.list_45partition_45by (\a b -> bool_to_reuse (f a b)) (list_to_reuse xs)) == Data.List.GroupBy.groupBy f xs

prop_list_filter :: Fun Int Bool -> [Int] -> Bool
prop_list_filter (Fn f) xs = list_to_hs (Reuse.list_45filter (bool_to_reuse . f) (list_to_reuse xs)) == filter f xs

prop_list_every :: Fun Int Bool -> [Int] -> Bool
prop_list_every (Fn f) xs = bool_to_hs (Reuse.list_45every_63 (bool_to_reuse . f) (list_to_reuse xs)) == all f xs

prop_list_any :: Fun Int Bool -> [Int] -> Bool
prop_list_any (Fn f) xs = bool_to_hs (Reuse.list_45any_63 (bool_to_reuse . f) (list_to_reuse xs)) == any f xs

prop_list_zip :: [Int] -> [Int] -> Bool
prop_list_zip xs ys = list_pair_to_hs (Reuse.list_45zip (list_to_reuse xs) (list_to_reuse ys)) == zip xs ys

quickCheckN f = quickCheck (withMaxSuccess 1000 f)

main = do
    quickCheckN prop_isomorphic
    quickCheckN prop_list_from_range
    quickCheckN prop_list_last
    quickCheckN prop_list_size
    quickCheckN prop_list_concat
    quickCheckN prop_list_reverse
    quickCheckN prop_list_map
--    quickCheckN prop_list_foldl
    quickCheckN prop_list_flatten
    quickCheckN prop_list_split_at
    quickCheckN prop_list_partition_by
    quickCheckN prop_list_filter
    quickCheckN prop_list_every
    quickCheckN prop_list_any
    quickCheckN prop_list_zip
