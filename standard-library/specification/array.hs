import Test.QuickCheck
import Test.QuickCheck.Modifiers (NonEmptyList (..))
import Data.Int
import qualified Data.Map as Map
import qualified ReuseStdlib as Reuse
import Conversions

prop_isomorphic :: Map.Map Int32 Int32 -> Bool
prop_isomorphic xs = array_to_hs (array_to_reuse xs) == xs

prop_array_set :: Int32 -> Int32 -> Map.Map Int32 Int32 -> Bool
prop_array_set k v xs = array_to_hs (Reuse.array_45set k v (array_to_reuse xs)) == Map.insert k v xs

prop_array_get :: Int32 -> Map.Map Int32 Int32 -> Bool
prop_array_get k xs = maybe_to_hs (Reuse.array_45get k (array_to_reuse xs)) == Map.lookup k xs

prop_array_entries :: Map.Map Int32 Int32 -> Bool
prop_array_entries xs = list_pair_to_hs (Reuse.array_45entries (array_to_reuse xs)) == Map.toList xs

quickCheckN f = quickCheck (withMaxSuccess 1000 f)

main = do
    quickCheckN prop_isomorphic
    quickCheckN prop_array_set
    quickCheckN prop_array_get
    quickCheckN prop_array_entries
