#!/usr/bin/env bash
set -e

script_path=$(dirname "$0")
project_root=$script_path/../..

extra_flags=
if [ "$1" == "--diagnostics" ]; then
    extra_flags="--diagnostics"
    DIAGNOSTICS="true"
fi

$project_root/standard-library/build.sh $extra_flags

[ -d $project_root/generated/extended ] || mkdir $project_root/generated/extended

if [ "$DIAGNOSTICS" == "true" ]; then
    2>&1 echo "[build.sh] reusec"
fi

$project_root/reusec $extra_flags\
                     --language haskell\
                     --output $project_root/generated/extended/CompilerHaskell.hs\
                     $project_root/sexp-parser/parser.reuse\
                     $project_root/parser/ast.reuse\
                     $project_root/parser/parser.strings\
                     $project_root/parser/strings.reuse\
                     $project_root/parser/parser.reuse\
                     $script_path/../common.strings\
                     $script_path/../common.reuse\
                     $script_path/../local-transforms.reuse\
                     $script_path/haskell.strings\
                     $script_path/haskell.reuse

cat << END_OF_SOURCE > $project_root/generated/extended/cli.hs
{-# LANGUAGE BangPatterns #-}
import System.Environment
import System.Exit
import System.CPUTime
import System.IO
import Text.Printf
import Data.Maybe
import Data.Int
import Numeric
import CompilerHaskell
import StdinWrapper
import Reuse

getenv name = do
    param <- lookupEnv name
    return (fromMaybe "" param)

io_as_minimal = do
    param <- getenv "REUSE_MINIMAL"
    return (if param == "true" then CTrue else CFalse)

io_with_stdlib = do
    param <- getenv "REUSE_NOSTDLIB"
    return (if param == "false" then CTrue else CFalse)

io_output_filename = do
    param <- getenv "REUSE_OUTPUT_FILENAME"
    return (StdinWrapper.string_to_reuse_string param)

io_performance = do
    param <- getenv "REUSE_TIME"
    return (param == "true")

main = do
    stdin_wrapper_start <- getCPUTime
    stdin_list <- StdinWrapper.stdin_list
    stdin_wrapper_end <- getCPUTime
    let stdin_wrapper_time = (fromIntegral (stdin_wrapper_end - stdin_wrapper_start)) / (10 ^ 12)

    parse_sexp_start <- getCPUTime
    let !parse_sexp_output = parse stdin_list
    parse_sexp_end <- getCPUTime
    let parse_sexp_time = (fromIntegral (parse_sexp_end - parse_sexp_start)) / (10 ^ 12)

    parse_start <- getCPUTime
    let !parse_output = stringify_45parse_45errors $ sexps_45to_45definitions parse_sexp_output
    parse_end <- getCPUTime
    let parse_time = (fromIntegral (parse_end - parse_start)) / (10 ^ 12)

    codegen_start <- getCPUTime
    as_minimal <- io_as_minimal
    with_stdlib <- io_with_stdlib
    output_filename <- io_output_filename
    let !codegen_output = to_45haskell output_filename with_stdlib parse_output stdin_list as_minimal
    codegen_end <- getCPUTime
    let codegen_time = (fromIntegral (codegen_end - codegen_start)) / (10 ^ 12)

    performance <- io_performance

    if performance then
        case codegen_output of
            CResult source -> do printf "%.6f %.6f %.6f %.6f %s" (stdin_wrapper_time :: Double) (parse_sexp_time :: Double) (parse_time :: Double) (codegen_time :: Double) (show (string_45size source))
                                 exitWith ExitSuccess
            CError error -> do hPrintf stderr "%s" (list_to_string error)
                               exitWith (ExitFailure 1)
    else
        case codegen_output of
            CResult source -> do printf "%s" (list_to_string source)
                                 exitWith ExitSuccess
            CError error -> do hPrintf stderr "%s" (list_to_string error)
                               exitWith (ExitFailure 1)

END_OF_SOURCE

compile_binary() {
    ghc $project_root/generated/Reuse.hs $project_root/extended/haskell-compiler/StdinWrapper.hs $project_root/generated/extended/CompilerHaskell.hs $project_root/generated/extended/cli.hs -o $project_root/generated/extended/compiler-haskell
}

if [ "$1" != "--no-binary" ]; then
    if [ "$1" == "--diagnostics" ]; then
        2>&1 echo "[build.sh] ghc"
        echo "Haskell:          " $(echo "time -p ghc $project_root/generated/Reuse.hs $project_root/extended/haskell-compiler/StdinWrapper.hs $project_root/generated/extended/CompilerHaskell.hs $project_root/generated/extended/cli.hs -o $project_root/generated/extended/compiler-haskell" | bash 2>&1 | grep "real" | awk '{ print $2; }')s
    else
        compile_binary
    fi
fi
