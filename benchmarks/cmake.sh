#!/bin/true

# Import functions for this benchmark
. ${executionPath}/common/benchmark-timer.sh
. ${executionPath}/common/compiler.sh

benchmarkSources=("llvm")
benchmarkSetup=("cp ${BT_CACHE_DIR}/llvm-10.0.0.src.tar.xz ."
                "tar xf llvm-10.0.0.src.tar.xz")
benchmarkLabels=("cmake LLVM")
benchmarkPretest=("cd $BT_RUNBENCHMARKS_DIR/llvm-10.0.0.src && rm -rf build && mkdir build && cd build")
benchmarkTest=("cmake .. -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} -DLLVM_TARGETS_TO_BUILD=host > $BT_RUNBENCHMARKS_DIR/build.log")
benchmarkValidation=("echo '0'")
benchmarkRepetition=(1)
benchmarkAnalyze=( "${benchmarkTest[@]}" )

requireTools cmake
