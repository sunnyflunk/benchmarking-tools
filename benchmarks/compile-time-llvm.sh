#!/bin/true

benchmarkSources=("llvm")
benchmarkSetup=("cp ${BT_CACHE_DIR}/llvm-10.0.0.src.tar.xz ."
                "tar xf llvm-10.0.0.src.tar.xz")
benchmarkLabels=("Build LLVM")
benchmarkPretest=("cd $BT_RUNBENCHMARKS_DIR/llvm-10.0.0.src && rm -rf build && mkdir build && cd build && cmake .. -DLLVM_TARGETS_TO_BUILD=host")
benchmarkTest=("make -j4 llvm-ar > $BT_RUNBENCHMARKS_DIR/build.log")
benchmarkValidation=("wc -c $BT_RUNBENCHMARKS_DIR/llvm-10.0.0.src/build/bin/llvm-ar | cut -d ' ' -f 1")
benchmarkRepetition=(1)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh
. ${executionPath}/common/compiler.sh

requireTools cmake make
