#!/usr/bin/env zsh

set -xe

mkdir -p build

# clang -O0 -g -std=gnu17 -o build/h64 -Isrc/ src/**/*.c
clang -O3 -std=gnu17 -o build/h64 -Isrc/ src/**/*.c

copier=cp

if [ `uname` = "Darwin" ]; then
    copier=ditto
fi

$copier build/h64 hive64-unknown-as
$copier build/h64 hive64-unknown-run
$copier build/h64 hive64-unknown-ld
$copier build/h64 hive64-unknown-dis
$copier build/h64 hive64-unknown-dbg
$copier build/h64 h64

rm -rf build
