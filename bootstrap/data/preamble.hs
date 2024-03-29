import Data.Int (Int32)
import qualified Prelude
import Prelude ((+), (*), (-), (<), (>=), (<=), (&&), (.), ($))
import Data.Bits ((.&.))
import qualified Data.ByteString as ByteString
_int32_add :: Int32 -> Int32 -> Int32
_int32_add a b = a + b

_int32_mul :: Int32 -> Int32 -> Int32
_int32_mul a b = a * b

_int32_sub :: Int32 -> Int32 -> Int32
_int32_sub a b = a - b

_int32_and :: Int32 -> Int32 -> Int32
_int32_and a b = a .&. b
slice_empty :: ByteString.ByteString
slice_empty = ByteString.empty
slice_of_u8 :: Int32 -> Int32 -> ByteString.ByteString
slice_of_u8 x count =
    if x >= 0 && x < 256 && count >= 1 then
        ByteString.replicate (Prelude.fromIntegral count) (Prelude.fromIntegral x)
    else
        ByteString.singleton 0
slice_size :: ByteString.ByteString -> Int32
slice_size = Prelude.fromIntegral . ByteString.length
slice_get :: ByteString.ByteString -> Int32 -> Int32
slice_get slice i =
    if i >= 0 && i < slice_size slice then
        Prelude.fromIntegral $ ByteString.index slice (Prelude.fromIntegral i)
    else
        0
slice_concat :: ByteString.ByteString -> ByteString.ByteString -> ByteString.ByteString
slice_concat = ByteString.append
slice_foldl :: (Int32 -> a -> a) -> a -> ByteString.ByteString -> a
slice_foldl f ys xs = slice_foldl 0 f ys xs where
    slice_foldl i f ys xs =
        if i < Prelude.fromIntegral (slice_size xs) then
            slice_foldl (i + 1) f (f (Prelude.fromIntegral (ByteString.index xs i)) ys) xs
        else
            ys
slice_subslice :: ByteString.ByteString -> Int32 -> Int32 -> ByteString.ByteString
slice_subslice slice s e =
    let size = slice_size slice in
    let s' = if s < 0 then 0 else (if s >= size then size - 1 else s) in
    let e' = if e < 0 then 0 else (if e >= size then size - 1 else e) in
    if e' - s' <= 0 then
        slice_empty
    else
        ByteString.take (Prelude.fromIntegral (e' - s')) (ByteString.drop (Prelude.fromIntegral s') slice)