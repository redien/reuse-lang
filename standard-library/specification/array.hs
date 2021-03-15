{-# LANGUAGE DeriveGeneric #-}
import Debug.Trace
import GHC.Generics
import Test.QuickCheck
import Test.QuickCheck.Modifiers (NonEmptyList (..))
import Data.Int
import qualified Data.Map as Map
import qualified ReuseStdlib as Reuse
import Conversions

data ReuseArray
    = AEmpty
    | ASet Int32 Int32 ReuseArray
    | ARemove Int32 ReuseArray
    deriving Generic

instance Show ReuseArray where
    show AEmpty = "(array-empty)"
    show (ASet k v xs) = "(array-set " ++ (show k) ++ " " ++ (show v) ++ " " ++ (show xs) ++ ")"
    show (ARemove k xs) = "(array-remove " ++ (show k) ++ " " ++ (show xs) ++ ")"

emptyGen :: Gen ReuseArray
emptyGen = return AEmpty

setGen :: Int -> Gen ReuseArray
setGen n = do
    k <- arbitrary
    v <- arbitrary
    xs <- arbitraryReuseArray (n - 1)
    return (ASet k v xs)

removeGen :: Int -> Gen ReuseArray
removeGen n = do
    k <- arbitrary
    xs <- arbitraryReuseArray (n - 1)
    return (ARemove k xs)

arbitraryReuseArray :: Int -> Gen ReuseArray
arbitraryReuseArray 0 = emptyGen
arbitraryReuseArray n = frequency [(2, setGen n), (1, removeGen n)]

instance Arbitrary ReuseArray where
    arbitrary = do
        x <- oneof [arbitraryReuseArray 1, arbitraryReuseArray 2, arbitraryReuseArray 3, sized arbitraryReuseArray]
        return x
    shrink x = shrinkToNil x ++ genericShrink x
        where
            shrinkToNil AEmpty = []
            shrinkToNil _ = [AEmpty]

evalReuse :: ReuseArray -> Reuse.Array Int32
evalReuse AEmpty = Reuse.array_empty
evalReuse (ASet k v xs) = Reuse.array_set k v (evalReuse xs)
evalReuse (ARemove k xs) = Reuse.array_remove k (evalReuse xs)

evalHs :: ReuseArray -> Map.Map Int32 Int32
evalHs AEmpty = Map.empty
evalHs (ASet k v xs) = Map.insert k v (evalHs xs)
evalHs (ARemove k xs) = Map.delete k (evalHs xs)

prop_isomorphic :: Map.Map Int32 Int32 -> Bool
prop_isomorphic xs = array_to_hs (array_to_reuse xs) == xs

prop_equivalence :: ReuseArray -> Bool
prop_equivalence xs = array_to_hs (evalReuse xs) == evalHs xs

prop_array_get :: Int32 -> ReuseArray -> Bool
prop_array_get k xs = maybe_to_hs (Reuse.array_get k (evalReuse xs)) == Map.lookup k (evalHs xs)

prop_array_entries :: ReuseArray -> Bool
prop_array_entries xs = list_pair_to_hs (Reuse.array_entries (evalReuse xs)) == Map.toList (evalHs xs)

prop_array_size :: ReuseArray -> Bool
prop_array_size xs = fromIntegral (Reuse.array_size (evalReuse xs)) == Map.size (evalHs xs)

quickCheckN f = quickCheck (withMaxSuccess 1000 f)

main = do
    quickCheckN prop_isomorphic
    quickCheck (withMaxSuccess 100000 prop_equivalence)
    quickCheckN prop_array_get
    quickCheckN prop_array_entries
    quickCheckN prop_array_size
