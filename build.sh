#!/usr/bin/env zsh

set -xe

mkdir -p build

# clang -O0 -g -std=c99 -o build/h64 -Isrc/ src/**/*.c -pedantic
clang -O3 -std=c99 -o build/h64 -Isrc/ src/**/*.c -pedantic

cp build/h64 h64-as
cp build/h64 h64
cp build/h64 h64-ld
cp build/h64 h64-dis

rm -rf build
