module Conversions where
import qualified ReuseStdlib as Reuse
import qualified Data.Map as Map
import qualified Data.Char as Char
import Data.Int
import Data.Bifunctor

list_to_reuse :: [a] -> Reuse.Tlist a
list_to_reuse = foldr Reuse.list_45cons Reuse.list_45empty

list_list_to_reuse :: [[a]] -> Reuse.Tlist (Reuse.Tlist a)
list_list_to_reuse xs = Reuse.list_45map list_to_reuse (list_to_reuse xs)

list_to_hs :: Reuse.Tlist a -> [a]
list_to_hs = Reuse.list_45foldr (:) []

list_list_to_hs :: Reuse.Tlist (Reuse.Tlist a) -> [[a]]
list_list_to_hs xs = map list_to_hs (list_to_hs xs)

pair_to_reuse :: (a, b) -> Reuse.Tpair a b
pair_to_reuse (x, y) = Reuse.CPair x y

pair_to_hs :: Reuse.Tpair a b -> (a, b)
pair_to_hs (Reuse.CPair x y) = (x, y)

pair_list_to_hs :: Reuse.Tpair (Reuse.Tlist a) (Reuse.Tlist b) -> ([a], [b])
pair_list_to_hs p = pair_to_hs (Reuse.pair_45bimap list_to_hs list_to_hs p)

list_pair_to_reuse :: [(a, b)] -> Reuse.Tlist (Reuse.Tpair a b)
list_pair_to_reuse xs = list_to_reuse (map pair_to_reuse xs)

list_pair_to_hs :: Reuse.Tlist (Reuse.Tpair a b) -> [(a, b)]
list_pair_to_hs xs = list_to_hs (Reuse.list_45map pair_to_hs xs)

bool_to_hs :: Reuse.Tboolean -> Bool
bool_to_hs b = case b of Reuse.CTrue -> True ; Reuse.CFalse -> False

bool_to_reuse :: Bool -> Reuse.Tboolean
bool_to_reuse b = case b of True -> Reuse.CTrue ; False -> Reuse.CFalse

maybe_to_hs :: Reuse.Tmaybe a -> Maybe a
maybe_to_hs (Reuse.CSome x) = Just x
maybe_to_hs Reuse.CNone = Nothing

string_to_reuse :: String -> Reuse.Tstring
string_to_reuse s = foldl (\a b -> Reuse.string_45append (fromIntegral (Char.ord b)) a) Reuse.string_45empty s

string_to_hs :: Reuse.Tstring -> String
string_to_hs s = Reuse.string_45foldl (\a b -> b ++ [(Char.chr (fromIntegral a))]) "" s

dictionary_to_hs :: Reuse.Tdictionary a -> Map.Map String a
dictionary_to_hs xs = Map.fromList (map (bimap string_to_hs id) (list_pair_to_hs (Reuse.dictionary_45entries xs)))

dictionary_to_reuse :: Map.Map String a -> Reuse.Tdictionary a
dictionary_to_reuse xs = Reuse.dictionary_45of (list_pair_to_reuse (map (bimap string_to_reuse id) (Map.toList xs)))

array_to_hs :: Reuse.Tarray a -> Map.Map Int32 a
array_to_hs xs = Map.fromList (list_pair_to_hs (Reuse.array_45entries xs))

array_to_reuse :: Map.Map Int32 a -> Reuse.Tarray a
array_to_reuse xs = Reuse.array_45of (list_pair_to_reuse (Map.toList xs))
