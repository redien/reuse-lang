import Test.QuickCheck
import Test.QuickCheck.Modifiers (NonEmptyList (..))
import qualified Data.Map as Map
import Data.Int
import Data.Bifunctor
import qualified ReuseStdlib as Reuse
import Conversions

prop_isomorphic :: Map.Map String Int32 -> Bool
prop_isomorphic xs = dictionary_to_hs (dictionary_to_reuse xs) == xs

prop_dictionary_set :: String -> Int32 -> Map.Map String Int32 -> Bool
prop_dictionary_set s x xs = dictionary_to_hs (Reuse.dictionary_45set (string_to_reuse s) x (dictionary_to_reuse xs)) == Map.insert s x xs

prop_dictionary_get :: String -> Map.Map String Int32 -> Bool
prop_dictionary_get k xs = maybe_to_hs (Reuse.dictionary_45get (string_to_reuse k) (dictionary_to_reuse xs)) == Map.lookup k xs

prop_dictionary_entries :: Map.Map String Int32 -> Bool
prop_dictionary_entries xs = map (bimap string_to_hs id) (list_pair_to_hs (Reuse.dictionary_45entries (dictionary_to_reuse xs))) == Map.toList xs

quickCheckN f = quickCheck (withMaxSuccess 100 f)

main = do
    quickCheckN prop_isomorphic
    quickCheckN prop_dictionary_set
    quickCheckN prop_dictionary_get
    quickCheckN prop_dictionary_entries
