#!/bin/true

if [[ $(which clang 2>/dev/null) ]]; then
    CC="clang"
    CXX="clang++"
    benchmarkNote="clang"
elif [[ $(which gcc 2>/dev/null) ]]; then
    CC="gcc"
    CXX="g++"
    benchmarkNote="gcc"
else
    printError "No usable compiler was found"
    exit 1
fi

CFLAGS="-O3 -flto"
CXXFLAGS="-O3 -flto"
