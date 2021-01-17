
let random_string n =
  let buffer = Buffer.create n in
  for i = 1 to n do
    Buffer.add_char buffer (Char.chr (Random.int 255))
  done ;
  Buffer.contents buffer;;

let random_strings number_of_strings length_of_strings =
  let strings = Array.make number_of_strings (Reuse.string_45empty ()) in
  for i = 0 to number_of_strings - 1 do
    Array.set strings i (Reuse.ml_string_to_reuse (random_string length_of_strings))
  done ;
  strings;;

let rec dictionary_set_keys keys i dict =
  if i > 0 then
    dictionary_set_keys keys (i - 1) (Reuse.dictionary_45set (Array.get keys i) 1 dict)
  else
    dict;;

let number_of_keys = 10000;;
let length_of_keys = 10;;
let keys = random_strings number_of_keys length_of_keys;;

let start_time = Unix.gettimeofday ();;
dictionary_set_keys keys (number_of_keys - 1) (Reuse.dictionary_45empty ());;
let end_time = Unix.gettimeofday ();;

let time = end_time -. start_time;;
Printf.printf "%f" time
