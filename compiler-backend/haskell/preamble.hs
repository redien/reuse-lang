import Data.Int (Int32)
import qualified Prelude
import Prelude ((+), (*), (-), (<))
import Data.Bits ((.&.))
_int32_add :: Int32 -> Int32 -> Int32
_int32_add a b = a + b

_int32_mul :: Int32 -> Int32 -> Int32
_int32_mul a b = a * b

_int32_sub :: Int32 -> Int32 -> Int32
_int32_sub a b = a - b

_int32_and :: Int32 -> Int32 -> Int32
_int32_and a b = a .&. b
