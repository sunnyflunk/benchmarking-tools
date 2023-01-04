#!/bin/true

CC="clang"
CXX="clang++"

CFLAGS="-O3 -march=x86-64-v2 -flto"
CXXFLAGS="-O3 -march=x86-64-v2 -flto"

requireTools clang clang++
