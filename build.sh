#!/usr/bin/env zsh

set -xe

mkdir -p build
clang -O2 -g -std=gnu17 -o build/h64 -Isrc/ src/**/*.c
