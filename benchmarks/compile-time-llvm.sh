#!/bin/true

benchmarkSources=("llvm")
benchmarkSetup=("cp ${BT_CACHE_DIR}/llvm-10.0.0.src.tar.xz ."
                "tar xf llvm-10.0.0.src.tar.xz")
benchmarkLabels=("Build LLVM")
benchmarkPretest=("cd $BT_RUNBENCHMARKS_DIR/llvm-10.0.0.src"
                  "rm -rf build"
                  "mkdir build"
                  "cd build"
                  "cmake .. -DLLVM_TARGETS_TO_BUILD=host")
benchmarkTest=("make -j4 llvm-ar > $BT_RUNBENCHMARKS_DIR/build.log")
benchmarkValidation=("wc -c $BT_RUNBENCHMARKS_DIR/llvm-10.0.0.src/build/bin/llvm-ar | cut -d ' ' -f 1")
benchmarkRepetition=(1)
benchmarkAnalyze=("${benchmarkTest[@]}")

if [[ `which clang 2>/dev/null` ]]; then
    CC="clang"
    CXX="clang++"
    benchmarkNote="clang"
elif [[ `which gcc 2>/dev/null` ]]; then
    CC="gcc"
    CXX="g++"
    benchmarkNote="gcc"
else
    printError "No usable compiler was found"
    exit 1
fi

CFLAGS="-O3 -flto"
CXXFLAGS="-O3 -flto"
