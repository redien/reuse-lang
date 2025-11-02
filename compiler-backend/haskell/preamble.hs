import GHC.Exts (
    State#,
    Int(I#), Word(W#), andI#, orI#, xorI#, isTrue#, (+#),
    ByteArray#, MutableByteArray#, shrinkMutableByteArray#, unsafeFreezeByteArray#, newByteArray#, sizeofByteArray#, copyByteArray#,
    Int32#, writeInt32Array#, indexInt32Array#, intToInt32#, int32ToInt#, plusInt32#, subInt32#, timesInt32#, quotInt32#, ltInt32#, leInt32#, gtInt32#, geInt32#, eqInt32#, neInt32#, negateInt32#,
    Word32#, notWord32#, andWord32#, orWord32#, xorWord32#, int32ToWord32#, word32ToInt32#, writeWord32Array#,
    Word8#, writeWord8Array#, indexWord8Array#, wordToWord8#, word8ToWord#)
import GHC.ST

import Data.Typeable (Typeable)

import Data.Int (Int32)
import Data.Word (Word8)
import qualified Prelude
import Prelude ((+), (*), (-), (==), (/=), (<), (>), (>=), (<=), (&&), (.), ($), (++))
import Data.Bits ((.&.), (.|.))
_int32_add :: Int32 -> Int32 -> Int32
_int32_add a b = a + b

_int32_mul :: Int32 -> Int32 -> Int32
_int32_mul a b = a * b

_int32_sub :: Int32 -> Int32 -> Int32
_int32_sub a b = a - b

_int32_and :: Int32 -> Int32 -> Int32
_int32_and a b = a .&. b

data ByteArray = ByteArray ByteArray# deriving ( Typeable )
data MutableByteArray s = MutableByteArray (MutableByteArray# s) deriving ( Typeable )

-- https://hackage.haskell.org/package/base-4.20.0.1/docs/GHC-Exts.html

_min :: Int32# -> Int32# -> Int32#
_min a b =
    if isTrue# (a `ltInt32#` b) then
        a
    else
        b

_max :: Int32# -> Int32# -> Int32#
_max a b =
    if isTrue# (a `gtInt32#` b) then
        a
    else
        b

_box :: Int32# -> Int32
_box x = Prelude.fromIntegral (I# (int32ToInt# x))

_unbox :: Int32 -> Int32#
_unbox x =
    let (I# x') = Prelude.fromIntegral x
    in intToInt32# x'

_box8 :: Word8# -> Word8
_box8 x = Prelude.fromIntegral (W# (word8ToWord# x))

_unbox8 :: Word8 -> Word8#
_unbox8 x =
    let (W# x') = Prelude.fromIntegral x
    in wordToWord8# x'

_box_array :: ByteArray# -> ByteArray
_box_array x = (ByteArray x)

_unbox_array :: ByteArray -> ByteArray#
_unbox_array x = let (ByteArray array) = x in array

_int32_to_word8 :: Int32# -> Word8#
_int32_to_word8 x =
    _unbox8 (Prelude.fromIntegral (_box x))

_word8_to_int32 :: Word8# -> Int32#
_word8_to_int32 x =
    _unbox (Prelude.fromIntegral (_box8 x))


-- Returns the size of an unboxed byte array in int32-sized elements
_byte_array_size :: ByteArray# -> Int32#
_byte_array_size arr =
    quotInt32# (intToInt32# (sizeofByteArray# arr)) (intToInt32# 4#)

-- Left fold on an unboxed byte array
_array_foldl_u8 :: Int32# -> Int32# -> (Int32# -> x -> x) -> x -> ByteArray# -> x
_array_foldl_u8 i length# f ys xs =
    if isTrue# (i `ltInt32#` length#) then
        _array_foldl_u8 (i `plusInt32#` (intToInt32# 1#)) length# f (f (_word8_to_int32 (indexWord8Array# xs (int32ToInt# i))) ys) xs
    else
        ys

_array_generate_u8' :: Int32# -> Int32# -> Int32# -> (MutableByteArray s) -> State# s -> (# State# s, (MutableByteArray s) #)
_array_generate_u8' i length# x (MutableByteArray ys#) s =
    if isTrue# (i `ltInt32#` length#) then
        let index# = int32ToInt# i in
        case writeWord8Array# ys# index# (_int32_to_word8 x) s of
            s' -> _array_generate_u8' (i `plusInt32#` (intToInt32# 1#)) length# x (MutableByteArray ys#) s'
    else
        (# s, (MutableByteArray ys#) #)

-- Applies ƒ to all elements in an array and returns the result
_array_generate_u8 :: Int32# -> Int32# -> ByteArray
_array_generate_u8 length# x# = runST $ ST $ \s ->
    case newByteArray# (int32ToInt# length#) s of
        (# s', result# #) -> case _array_generate_u8' (intToInt32# 0#) length# x# (MutableByteArray result#) s' of
            (# s'', (MutableByteArray result'#) #) -> case unsafeFreezeByteArray# result'# s'' of
                (# s''', result''# #) -> (# s''', (ByteArray result''#) #)

-- Returns an empty byte array
_empty_byte_array :: ByteArray
_empty_byte_array = runST $ ST $ \s ->
    case newByteArray# 0# s of
        (# s', arr# #) -> case unsafeFreezeByteArray# arr# s' of
            (# s'', arr'# #) -> (# s'', ByteArray arr'# #)

-- Concatenates two byte arrays
_concat_arrays :: ByteArray# -> ByteArray# -> ByteArray#
_concat_arrays a# b# = _unbox_array $ runST $ ST $ \s -> 
    let new_size = (sizeofByteArray# a#) +# (sizeofByteArray# b#) in
    case newByteArray# new_size s of
        (# s', arr# #) -> case copyByteArray# a# 0# arr# 0# (sizeofByteArray# a#) s' of
            s'' -> case copyByteArray# b# 0# arr# (sizeofByteArray# a#) (sizeofByteArray# b#) s'' of
                s''' -> case unsafeFreezeByteArray# arr# s''' of
                    (# s'''', arr'# #) -> (# s'''', ByteArray arr'# #)

slice_empty :: ByteArray
slice_empty = _empty_byte_array
slice_of_u8 :: Int32 -> Int32 -> ByteArray
slice_of_u8 x count = _array_generate_u8 (_unbox count) (_unbox x)
slice_size :: ByteArray -> Int32
slice_size a = (_box (intToInt32# (sizeofByteArray# (_unbox_array a))))
slice_get :: ByteArray -> Int32 -> Int32
slice_get slice index = Prelude.fromIntegral (_box8 (indexWord8Array# (_unbox_array slice) (int32ToInt# (_unbox index))))
slice_concat :: ByteArray -> ByteArray -> ByteArray
slice_concat a b = _box_array (_concat_arrays (_unbox_array a) (_unbox_array b))
slice_foldl :: (Int32 -> a -> a) -> a -> ByteArray -> a
slice_foldl f ys xs = _array_foldl_u8 (_unbox 0) (intToInt32# (sizeofByteArray# (_unbox_array xs))) (\x ys -> f (_box x) ys) ys (_unbox_array xs)
slice_subslice :: ByteArray -> Int32 -> Int32 -> ByteArray
slice_subslice arr start end = runST $ ST $ \s ->
    let a# = _unbox_array arr in
    let end# = _min (intToInt32# (sizeofByteArray# a#)) (_max (intToInt32# 0#) (_unbox end)) in
    let start# = _min end# (_max (intToInt32# 0#) (_unbox start)) in
    let new_size# = subInt32# end# start# in
    case newByteArray# (int32ToInt# new_size#) s of
        (# s', arr# #) -> case copyByteArray# a# (int32ToInt# start#) arr# 0# (int32ToInt# new_size#) s' of
            s'' -> case unsafeFreezeByteArray# arr# s'' of
                (# s''', arr'# #) -> (# s''', ByteArray arr'# #)

data ArrayBinaryOperator' =
     ArrayAdd
   | ArraySubtract
   | ArrayMultiply
   | ArrayDivide
   | ArrayAnd
   | ArrayOr
   | ArrayNand
   | ArrayXor
   | ArrayEqual
   | ArrayNotEqual
   | ArrayLessThan
   | ArrayLessThanEqual
   | ArrayGreaterThan
   | ArrayGreaterThanEqual

data Array' =
    ArrayOfInt32 Int32
  | ArrayConcat Array' Array'
  | ArrayGenerate Array' Int32
  | ArrayShape Array'
  | ArrayMap ArrayBinaryOperator' Array' Array'
  | ArrayReduce ArrayBinaryOperator' Int32 Array'
  | ArrayScan ArrayBinaryOperator' Int32 Array'
  | ArrayCompress Array' Array'
  | ArrayFromSlice ByteArray

-- Using Int32# might incur a large performance cost on platforms with a word size < 32 bits 
-- because it does not use prim ops but makes C FFI calls.
-- https://downloads.haskell.org/~ghc/7.2.2/docs/html/libraries/ghc-prim-0.2.0.0/GHC-Prim.html#g:1
_select_op :: ArrayBinaryOperator' -> Int32# -> Int32# -> Int32#
_select_op ArrayAdd = plusInt32#
_select_op ArraySubtract = subInt32#
_select_op ArrayMultiply = timesInt32#
_select_op ArrayDivide = \a b -> if isTrue# (eqInt32# b (intToInt32# 0#)) then (intToInt32# 0#) else quotInt32# a b
_select_op ArrayAnd = \a b -> word32ToInt32# ((int32ToWord32# a) `andWord32#` (int32ToWord32# b))
_select_op ArrayOr = \a b -> word32ToInt32# ((int32ToWord32# a) `orWord32#` (int32ToWord32# b))
_select_op ArrayNand = \a b -> word32ToInt32# (notWord32# ((int32ToWord32# a) `andWord32#` (int32ToWord32# b)))
_select_op ArrayXor = \a b -> word32ToInt32# ((int32ToWord32# a) `xorWord32#` (int32ToWord32# b))
_select_op ArrayEqual = \a b -> intToInt32# (eqInt32# a b)
_select_op ArrayNotEqual = \a b -> intToInt32# (neInt32# a b)
_select_op ArrayLessThan =  \a b -> intToInt32# (ltInt32# a b)
_select_op ArrayLessThanEqual =  \a b -> intToInt32# (leInt32# a b)
_select_op ArrayGreaterThan =  \a b -> intToInt32# (gtInt32# a b)
_select_op ArrayGreaterThanEqual =  \a b -> intToInt32# (geInt32# a b)

-- Returns number of elements represented by the shape
_size_from_shape :: ByteArray# -> Int32#
_size_from_shape shape = fold (intToInt32# 0#) (intToInt32# 1#) shape
    where fold i ys xs = if isTrue# (i `ltInt32#` (_byte_array_size xs))
                         then fold (i `plusInt32#` (intToInt32# 1#)) (timesInt32# (indexInt32Array# xs (int32ToInt# i)) ys) xs
                         else ys

-- Takes an integer and returns a byte array containing the integer
-- Desugaring the do notation is necessary since it won't work on unlifted values.
_singleton_byte_array :: Int32# -> ByteArray#
_singleton_byte_array value# = _unbox_array $ runST $ ST $ \s -> 
    case newByteArray# 4# s of
        (# s', arr# #) -> case writeInt32Array# arr# 0# value# s' of
            s'' -> case unsafeFreezeByteArray# arr# s'' of
                (# s''', arr'# #) -> (# s''', ByteArray arr'# #)

-- Left fold on an unboxed byte array
_array_foldl :: Int32# -> (Int32# -> x -> x) -> x -> ByteArray# -> x
_array_foldl i f ys xs =
    let length = _byte_array_size xs in
    if isTrue# (i `ltInt32#` length) then
        _array_foldl (i `plusInt32#` (intToInt32# 1#)) f (f (indexInt32Array# xs (int32ToInt# i)) ys) xs
    else
        ys

_array_foldl_int32' :: Int32# -> Int32# -> (Int32# -> Int32# -> Int32#) -> Int32# -> ByteArray# -> Int32#
_array_foldl_int32' i length f ys xs =
    if isTrue# (i `ltInt32#` length) then
        _array_foldl_int32' (i `plusInt32#` (intToInt32# 1#)) length f (f (indexInt32Array# xs (int32ToInt# i)) ys) xs
    else
        ys

-- Left fold on an unboxed byte array
_array_foldl_int32 :: (Int32# -> Int32# -> Int32#) -> Int32# -> ByteArray# -> Int32#
_array_foldl_int32 f ys xs =
    _array_foldl_int32' (intToInt32# 0#) (_byte_array_size xs) f ys xs

_array_map' :: Int32# -> Int32# -> (Int32# -> Int32#) -> ByteArray# -> (MutableByteArray s) -> State# s -> (# State# s, (MutableByteArray s) #)
_array_map' i length# f xs# (MutableByteArray ys#) s =
    if isTrue# (i `ltInt32#` length#) then
        let index# = int32ToInt# i in
        let value# = indexInt32Array# xs# index# in
        case writeInt32Array# ys# index# (f value#) s of
            s' -> _array_map' (i `plusInt32#` (intToInt32# 1#)) length# f xs# (MutableByteArray ys#) s'
    else
        (# s, (MutableByteArray ys#) #)

-- Applies ƒ to all elements in an array and returns the result
_array_map :: (Int32# -> Int32#) -> ByteArray# -> ByteArray#
_array_map f xs# = _unbox_array $ runST $ ST $ \s ->
    case newByteArray# (sizeofByteArray# xs#) s of
        (# s', result# #) -> case _array_map' (intToInt32# 0#) (_byte_array_size xs#) f xs# (MutableByteArray result#) s' of
            (# s'', (MutableByteArray result'#) #) -> case unsafeFreezeByteArray# result'# s'' of
                (# s''', result''# #) -> (# s''', (ByteArray result''#) #)

_array_scan' :: Int32# -> Int32# -> Int32# -> (Int32# -> Int32# -> Int32#) -> ByteArray# -> (MutableByteArray s) -> State# s -> (# State# s, (MutableByteArray s) #)
_array_scan' i length# accumulator# f xs# (MutableByteArray ys#) s =
    if isTrue# (i `ltInt32#` length#) then
        let index# = int32ToInt# i in
        let value# = indexInt32Array# xs# index# in
        let new_acc# = f accumulator# value# in
        case writeInt32Array# ys# index# new_acc# s of
            s' -> _array_scan' (i `plusInt32#` (intToInt32# 1#)) length# new_acc# f xs# (MutableByteArray ys#) s'
    else
        (# s, (MutableByteArray ys#) #)

-- Reduces array with ƒ and returns an array with all intermediate results
_array_scan :: Int32# -> (Int32# -> Int32# -> Int32#) -> ByteArray# -> ByteArray#
_array_scan initial# f xs# = _unbox_array $ runST $ ST $ \s ->
    case newByteArray# (sizeofByteArray# xs#) s of
        (# s', result# #) -> case _array_scan' (intToInt32# 0#) (_byte_array_size xs#) initial# f xs# (MutableByteArray result#) s' of
            (# s'', (MutableByteArray result'#) #) -> case unsafeFreezeByteArray# result'# s'' of
                (# s''', result''# #) -> (# s''', (ByteArray result''#) #)

_array_map2' :: Int32# -> Int32# -> (Int32# -> Int32# -> Int32#) -> ByteArray# -> ByteArray# -> (MutableByteArray s) -> State# s -> State# s
_array_map2' i length# f a# b# (MutableByteArray result#) s =
    if isTrue# (i `ltInt32#` length#) then
        let index# = int32ToInt# i in
        let value_a# = indexInt32Array# a# index# in
        let value_b# = indexInt32Array# b# index# in
        case writeInt32Array# result# index# (f value_a# value_b#) s of
            s' -> _array_map2' (i `plusInt32#` (intToInt32# 1#)) length# f a# b# (MutableByteArray result#) s'
    else
        s

-- Applies ƒ to all elements in an array and returns the result
_array_map2 :: (Int32# -> Int32# -> Int32#) -> ByteArray#  -> ByteArray# -> ByteArray#
_array_map2 f a# b# = _unbox_array $ runST $ ST $ \s ->
    let length# = _min (_byte_array_size a#) (_byte_array_size b#) in
    case newByteArray# (int32ToInt# (length# `timesInt32#` (intToInt32# 4#))) s of
        (# s', result# #) -> case _array_map2' (intToInt32# 0#) length# f a# b# (MutableByteArray result#) s' of
            s'' -> case unsafeFreezeByteArray# result# s'' of
                (# s''', result'# #) -> (# s''', (ByteArray result'#) #)

_array_generate_i32' :: Int32# -> Int32# -> Int32# -> (MutableByteArray s) -> State# s -> (# State# s, (MutableByteArray s) #)
_array_generate_i32' i length# x (MutableByteArray ys#) s =
    if isTrue# (i `ltInt32#` length#) then
        let index# = int32ToInt# i in
        case writeInt32Array# ys# index# x s of
            s' -> _array_generate_i32' (i `plusInt32#` (intToInt32# 1#)) length# x (MutableByteArray ys#) s'
    else
        (# s, (MutableByteArray ys#) #)

-- Applies ƒ to all elements in an array and returns the result
_array_generate_i32 :: Int32# -> Int32# -> ByteArray#
_array_generate_i32 length# x# = _unbox_array $ runST $ ST $ \s ->
    case newByteArray# (int32ToInt# (length# `timesInt32#` (intToInt32# 4#))) s of
        (# s', result# #) -> case _array_generate_i32' (intToInt32# 0#) length# x# (MutableByteArray result#) s' of
            (# s'', (MutableByteArray result'#) #) -> case unsafeFreezeByteArray# result'# s'' of
                (# s''', result''# #) -> (# s''', (ByteArray result''#) #)

_compress' :: Int32# -> Int32# -> Int32# -> ByteArray# -> ByteArray# -> (MutableByteArray s) -> State# s -> (# State# s, Int32# #)
_compress' i j length# selection# values# (MutableByteArray result#) s =
    if isTrue# (i `ltInt32#` length#) then
        let value# = indexInt32Array# values# (int32ToInt# i) in
        let selected# = indexInt32Array# selection# (int32ToInt# i) in
        case writeInt32Array# result# (int32ToInt# j) value# s of
            s' -> _compress' (i `plusInt32#` (intToInt32# 1#)) (j `plusInt32#` (if isTrue# (selected# `neInt32#` (intToInt32# 0#)) then (intToInt32# 1#) else (intToInt32# 0#))) length# selection# values# (MutableByteArray result#) s'
    else
        (# s, j #)

-- Returns a new array with all elements in values where the corresponding element in selection is not 0.
_compress :: ByteArray# -> ByteArray# -> ByteArray#
_compress selection# values# = _unbox_array $ runST $ ST $ \s ->
    let length# = _min (_byte_array_size selection#) (_byte_array_size values#) in
    case newByteArray# (int32ToInt# (length# `timesInt32#` (intToInt32# 4#))) s of
        (# s', result# #) -> case _compress' (intToInt32# 0#) (intToInt32# 0#) length# selection# values# (MutableByteArray result#) s' of
            (# s'', new_length# #) -> case shrinkMutableByteArray# result# (int32ToInt# (new_length# `timesInt32#` (intToInt32# 4#))) s'' of
                s''' -> case unsafeFreezeByteArray# result# s''' of
                    (# s'''', result'# #) -> (# s'''', (ByteArray result'#) #)

_array_eval :: Array' -> (# ByteArray#, ByteArray# #)
_array_eval arr =
    let sizeFromShape shape = _array_foldl_int32 (\a b -> (a `_max` (intToInt32# 0#)) `timesInt32#` b) (intToInt32# 1#) shape in
    case arr of
        ArrayOfInt32 x -> (# _singleton_byte_array (intToInt32# 1#), _singleton_byte_array (_unbox x) #)
        ArrayConcat a b ->
            let (# shape_a, array_a #) = _array_eval a in
            let (# shape_b, array_b #) = _array_eval b in
            let new_array = _concat_arrays array_a array_b in
            (# (_singleton_byte_array (_byte_array_size new_array)), new_array #)
        ArrayGenerate shape' x ->
            let (# _, shape'' #) = _array_eval shape' in
            let shape = _compress (_array_map (\x -> (intToInt32# (leInt32# (intToInt32# 0#) x))) shape'') shape'' in
            if isTrue# (gtInt32# (_byte_array_size shape) (intToInt32# 0#)) then
                (# shape, _array_generate_i32 (_size_from_shape shape) (_unbox x) #)
            else
                let (ByteArray _empty_byte_array#) = _empty_byte_array in
                (# _empty_byte_array#, _empty_byte_array# #)
        ArrayShape array' ->
            let (# shape, _ #) = _array_eval array' in
            (# _singleton_byte_array (_byte_array_size shape), shape #)
        ArrayMap op a b ->
            let (# shape_a, array_a #) = _array_eval a in
            let (# shape_b, array_b #) = _array_eval b in
            let result = _array_map2 (_select_op op) array_a array_b in
            (# _singleton_byte_array (_byte_array_size result), result #)
        ArrayReduce op k array ->
            let (# shape, values #) = _array_eval array in
            let result = _array_foldl_int32 (_select_op op) (_unbox k) values in
            (# _singleton_byte_array (intToInt32# 1#), _singleton_byte_array result #)
        ArrayScan op k array ->
            let (# shape, values #) = _array_eval array in
            let result = _array_scan (_unbox k) (_select_op op) values in
            (# _singleton_byte_array (_byte_array_size result), result #)
        ArrayCompress a b ->
            let (# shape_a, array_a #) = _array_eval a in
            let (# shape_b, array_b #) = _array_eval b in
            let result = _compress array_a array_b in
            (# _singleton_byte_array (_byte_array_size result), result #)
        ArrayFromSlice slice ->
            let slice# = _unbox_array slice in
            (# _singleton_byte_array (_byte_array_size slice#), slice# #)

array_foldl :: (x -> Int32 -> x) -> x -> Array' -> x
array_foldl f ys xs' =
    let (# _, xs #) = _array_eval xs' in
    _array_foldl (intToInt32# 0#) (\a b -> f b (_box a)) ys xs

array_to_slice :: Array' -> ByteArray
array_to_slice xs =
    let (# _, xs# #) = _array_eval xs in
    _box_array xs#
