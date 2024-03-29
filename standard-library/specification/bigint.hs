{-# LANGUAGE DeriveGeneric #-}
import Debug.Trace
import GHC.Generics
import Test.QuickCheck
import Test.QuickCheck.Modifiers (NonEmptyList (..))
import Test.QuickCheck.Monadic (monadicIO, pick, pre, run, assert)
import Data.Int
import qualified ReuseStdlib as Reuse
import Conversions

data ReuseBigint
    = BZero
    | BOne
    | BFrom Int32
    | BAdd ReuseBigint ReuseBigint
    | BSubtract ReuseBigint ReuseBigint
    | BMultiply ReuseBigint ReuseBigint
    | BNegate ReuseBigint
    deriving Generic

instance Show ReuseBigint where
    show BZero = "(bigint-zero)"
    show BOne = "(bigint-one)"
    show (BFrom a) = "(bigint-from " ++ (show a) ++ ")"
    show (BAdd a b) = "(bigint-add " ++ (show a) ++ " " ++ (show b) ++ ")"
    show (BSubtract a b) = "(bigint-subtract " ++ (show a) ++ " " ++ (show b) ++ ")"
    show (BMultiply a b) = "(bigint-multiply " ++ (show a) ++ " " ++ (show b) ++ ")"
    show (BNegate a) = "(bigint-negate " ++ (show a) ++ ")"

emptyGen :: Gen ReuseBigint
emptyGen = return BZero

oneGen :: Gen ReuseBigint
oneGen = return BOne

fromGen :: Int -> Gen ReuseBigint
fromGen n = do
    v <- arbitrary
    return (BFrom v)

addGen :: Int -> Gen ReuseBigint
addGen n = do
    a <- arbitraryReuseBigint (n `div` 2)
    b <- arbitraryReuseBigint (n `div` 2)
    return (BAdd a b)

subtractGen :: Int -> Gen ReuseBigint
subtractGen n = do
    a <- arbitraryReuseBigint (n `div` 2)
    b <- arbitraryReuseBigint (n `div` 2)
    return (BSubtract a b)

multiplyGen :: Int -> Gen ReuseBigint
multiplyGen n = do
    a <- arbitraryReuseBigint (n `div` 2)
    b <- arbitraryReuseBigint (n `div` 2)
    return (BMultiply a b)

negateGen :: Int -> Gen ReuseBigint
negateGen n = do
    v <- arbitraryReuseBigint (n - 1)
    return (BNegate v)

arbitraryReuseBigint :: Int -> Gen ReuseBigint
arbitraryReuseBigint 0 = emptyGen
arbitraryReuseBigint n = frequency [(3, addGen n), (2, negateGen n), (2, fromGen n), (1, subtractGen n), (1, multiplyGen n), (1, oneGen)]

instance Arbitrary ReuseBigint where
    arbitrary = do
        x <- oneof [arbitraryReuseBigint 1, arbitraryReuseBigint 2, arbitraryReuseBigint 3, sized arbitraryReuseBigint]
        return x
    shrink x = shrinkToNil x ++ genericShrink x
        where
            shrinkToNil BZero = []
            shrinkToNil _ = [BZero]

evalReuse :: ReuseBigint -> Reuse.Bigint
evalReuse BZero = Reuse.bigint_zero
evalReuse BOne = Reuse.bigint_one
evalReuse (BFrom v) = Reuse.bigint_from v
evalReuse (BAdd a b) = Reuse.bigint_add (evalReuse a) (evalReuse b)
evalReuse (BSubtract a b) = Reuse.bigint_subtract (evalReuse a) (evalReuse b)
evalReuse (BMultiply a b) = Reuse.bigint_multiply (evalReuse a) (evalReuse b)
evalReuse (BNegate v) = Reuse.bigint_negate (evalReuse v)

evalHs :: ReuseBigint -> Integer
evalHs BZero = 0
evalHs BOne = 1
evalHs (BFrom v) = fromIntegral v
evalHs (BAdd a b) = (evalHs a) + (evalHs b)
evalHs (BSubtract a b) = (evalHs a) - (evalHs b)
evalHs (BMultiply a b) = (evalHs a) * (evalHs b)
evalHs (BNegate v) = -(evalHs v)

prop_isomorphic :: Integer -> Bool
prop_isomorphic i = bigint_to_hs (bigint_to_reuse i) == i

prop_equivalence :: ReuseBigint -> Bool
prop_equivalence i = bigint_to_hs (evalReuse i) == evalHs i

prop_equivalence_backend :: String -> String -> ReuseBigint -> Property
prop_equivalence_backend lang source xs = monadicIO $ do
    result <- run $ evalExpr lang source $ "(bigint-to-string " ++ (show xs) ++ ")"
    assert $ (read result) == evalHs xs

prop_less_than :: Integer -> Integer -> Bool
prop_less_than a b = bool_to_hs (Reuse.bigint_less_than (bigint_to_reuse a) (bigint_to_reuse b)) == (a < b)

main = do
    quickCheck $ withMaxSuccess 100 $ prop_equivalence_backend "javascript" "executable.js"
    quickCheck $ withMaxSuccess 100 $ prop_equivalence_backend "ocaml" "executable.ml"
    quickCheck (withMaxSuccess 1000 prop_isomorphic)
    quickCheck (withMaxSuccess 100000 prop_equivalence)
    quickCheck (withMaxSuccess 100000 prop_less_than)
