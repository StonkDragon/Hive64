#!/usr/bin/env zsh

set -xe

./hive64-unknown-as main.hive64 libc.hive64
./hive64-unknown-ld main.rcx -lc -o main
./hive64-unknown-ld libc.rcx -o libc.dll
