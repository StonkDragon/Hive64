#!/usr/bin/env zsh

set -xe

mkdir -p build

python3 decodetree.py hive64.decode > src/decode.h

# clang -O0 -g -std=gnu17 -o build/h64 -Isrc/ src/**/*.c -lm
clang -O3 -std=gnu17 -o build/h64 -Isrc/ src/**/*.c -lm

copier=cp

if [ `uname` = "Darwin" ]; then
    copier=ditto
fi

$copier build/h64 hive64-unknown-as
$copier build/h64 hive64-unknown-run
$copier build/h64 hive64-unknown-ld
$copier build/h64 hive64-unknown-dis
$copier build/h64 hive64-unknown-mcas
$copier build/h64 hive64-unknown-shell
$copier build/h64 h64

rm -rf build
