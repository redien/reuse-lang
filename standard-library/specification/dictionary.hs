{-# LANGUAGE DeriveGeneric #-}
import GHC.Generics
import Test.QuickCheck
import Test.QuickCheck.Modifiers (NonEmptyList (..))
import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.Int
import Data.Bifunctor
import qualified ReuseStdlib as Reuse
import Conversions

data ReuseDictionary
    = DEmpty
    | DSet String Int32 ReuseDictionary
    | DRemove String ReuseDictionary
    deriving Generic

instance Show ReuseDictionary where
    show DEmpty = "(dictionary-empty)"
    show (DSet k v xs) = "(dictionary-set " ++ (show k) ++ " " ++ (show v) ++ " " ++ (show xs) ++ ")"
    show (DRemove k xs) = "(dictionary-remove " ++ (show k) ++ " " ++ (show xs) ++ ")"

emptyGen :: Gen ReuseDictionary
emptyGen = return DEmpty

setGen :: Int -> Gen ReuseDictionary
setGen n = do
    k <- arbitrary
    v <- arbitrary
    xs <- arbitraryReuseDictionary (n - 1)
    return (DSet k v xs)

removeGen :: Int -> Gen ReuseDictionary
removeGen n = do
    k <- arbitrary
    xs <- arbitraryReuseDictionary (n - 1)
    return (DRemove k xs)

arbitraryReuseDictionary :: Int -> Gen ReuseDictionary
arbitraryReuseDictionary 0 = emptyGen
arbitraryReuseDictionary n = frequency [(2, setGen n), (1, removeGen n)]

instance Arbitrary ReuseDictionary where
    arbitrary = do
        x <- oneof [arbitraryReuseDictionary 1, arbitraryReuseDictionary 2, arbitraryReuseDictionary 3, sized arbitraryReuseDictionary]
        return x
    shrink x = shrinkToNil x ++ genericShrink x
        where
            shrinkToNil DEmpty = []
            shrinkToNil _ = [DEmpty]

evalReuse :: ReuseDictionary -> Reuse.Dictionary Int32
evalReuse DEmpty = Reuse.dictionary_empty
evalReuse (DSet k v xs) = Reuse.dictionary_set (string_to_reuse k) v (evalReuse xs)
evalReuse (DRemove k xs) = Reuse.dictionary_remove (string_to_reuse k) (evalReuse xs)

evalHs :: ReuseDictionary -> Map.Map String Int32
evalHs DEmpty = Map.empty
evalHs (DSet k v xs) = Map.insert k v (evalHs xs)
evalHs (DRemove k xs) = Map.delete k (evalHs xs)

prop_isomorphic :: Map.Map String Int32 -> Bool
prop_isomorphic xs = dictionary_to_hs (dictionary_to_reuse xs) == xs

prop_equivalence :: ReuseDictionary -> Bool
prop_equivalence xs = dictionary_to_hs (evalReuse xs) == evalHs xs

prop_dictionary_get :: String -> ReuseDictionary -> Bool
prop_dictionary_get k xs = maybe_to_hs (Reuse.dictionary_get (string_to_reuse k) (evalReuse xs)) == Map.lookup k (evalHs xs)

prop_dictionary_entries :: ReuseDictionary -> Bool
prop_dictionary_entries xs = Set.fromList (map (bimap string_to_hs id) (list_pair_to_hs (Reuse.dictionary_entries (evalReuse xs)))) == Set.fromList (Map.toList (evalHs xs))

prop_dictionary_size :: ReuseDictionary -> Bool
prop_dictionary_size xs = (Reuse.dictionary_size (evalReuse xs)) == fromIntegral (Map.size (evalHs xs))

quickCheckN f = quickCheck (withMaxSuccess 100 f)

main = do
    quickCheckN prop_isomorphic
    quickCheck (withMaxSuccess 100000 prop_equivalence)
    quickCheckN prop_dictionary_size
    quickCheckN prop_dictionary_get
    quickCheckN prop_dictionary_entries
