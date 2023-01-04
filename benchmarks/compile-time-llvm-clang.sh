#!/bin/true

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh
. ${executionPath}/common/compiler-clang.sh
. ${executionPath}/benchmarks/helpers/llvm.sh

benchmarkLabels=("Build LLVM")
benchmarkPretest=("cd $BT_RUNBENCHMARKS_DIR/llvm && rm -rf build && mkdir build && cd build && cmake .. -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} -DLLVM_TARGETS_TO_BUILD=host > $BT_RUNBENCHMARKS_DIR/cmake.log")
benchmarkTest=("make -j4 llvm-ar > $BT_RUNBENCHMARKS_DIR/build.log")
benchmarkValidation=("wc -c $BT_RUNBENCHMARKS_DIR/llvm/build/bin/llvm-ar | cut -d ' ' -f 1")
benchmarkRepetition=(1)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

requireTools cmake cut make wc
