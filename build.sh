#!/usr/bin/env zsh

set -xe

mkdir -p build

# clang -O0 -g -std=gnu17 -o build/h64 -Isrc/ src/**/*.c
clang -O3 -std=gnu17 -o build/h64 -Isrc/ src/**/*.c

cp build/h64 h64-as
cp build/h64 h64
cp build/h64 h64-ld
cp build/h64 h64-dis

rm -rf build
